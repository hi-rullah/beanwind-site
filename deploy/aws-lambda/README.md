# Deploying to AWS Lambda

The app runs **unchanged** on Lambda thanks to the [AWS Lambda Web Adapter](https://github.com/awslabs/aws-lambda-web-adapter):
Lambda starts the Spring Boot jar via `run.sh`, and the adapter forwards each request to it as plain HTTP on port 8080.
**SnapStart** snapshots the started JVM, so cold starts restore from the snapshot instead of booting Spring.

| File | Purpose |
|---|---|
| `template.yaml` | Infrastructure: function, public Function URL, log group (AWS SAM / CloudFormation) |
| `samconfig.toml` | `sam deploy` defaults: stack `javaview-site`, region `eu-south-1` |
| `run.sh` | Startup script launched by the Web Adapter |
| `deploy.cmd` | Builds the jar, puts jar + `run.sh` into `target/lambda/` (the Lambda package) and runs `sam deploy` |

Everything Lambda-specific lives in this folder — `pom.xml` has no Lambda configuration.

## How a request flows
```
Browser ──HTTPS──▶ Function URL ──▶ alias "live" ──▶ Lambda (java25, arm64)
                                                     ├─ Web Adapter (layer, /opt/bootstrap)
                                                     └─ run.sh ─▶ java -jar javaview-site.jar  (Spring Boot on :8080)
```

## Cloud Run → Lambda mapping
| Cloud Run | Here |
|---|---|
| `gcloud run deploy --source .` | `deploy\aws-lambda\deploy.cmd` |
| Container listens on `$PORT` | Web Adapter forwards to `:8080` (`AWS_LWA_PORT`) |
| `--allow-unauthenticated` | Function URL with `AuthType: NONE` |
| Scale to zero | Default on Lambda |
| Instance stays warm between requests | SnapStart: restore a pre-started JVM snapshot |

## Prerequisites
- Java 25 (`JAVA_HOME` pointing to it)
- [AWS SAM CLI](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/install-sam-cli.html) (`winget install Amazon.SAM-CLI`, then open a new terminal)
- AWS CLI credentials for an IAM user/role with these managed policies:
  `AWSCloudFormationFullAccess`, `AWSLambda_FullAccess`, `IAMFullAccess`, `AmazonS3FullAccess`, `CloudWatchLogsFullAccess`

## Why CloudFormation (and those permissions)?
SAM is a layer on top of CloudFormation. `sam deploy` uploads the package to S3, then hands `template.yaml` to CloudFormation,
which expands `AWS::Serverless::Function` into the real resources and creates them as **one stack** (`javaview-site`):
function, execution role, version + `live` alias, Function URL, 2 public-access permissions, log group.
CloudFormation acts with *your* permissions, hence Lambda/IAM/S3/Logs access too.
Benefits: automatic rollback on failure, redeploys apply only the diff, `sam delete` removes everything.

SAM also creates a helper stack `aws-sam-cli-managed-default` with the S3 bucket that stores uploaded packages.

## Deploy / redeploy
From anywhere (Windows):
```
deploy\aws-lambda\deploy.cmd
```
It runs `mvnw clean package`, copies `target\javaview-site.jar` + `run.sh` into `target\lambda\`, then `sam deploy`,
which shows the changeset and asks for confirmation (`confirm_changeset = true`).

- **Login cookie secret:** the template has a `AuthCookieSecret` parameter (becomes `AUTH_COOKIE_SECRET`, see
  `application-prod.yml`). Pass it on the **first** deploy, or to change it (signs everyone out):
  `deployws-lambda\deploy.cmd --parameter-overrides AuthCookieSecret=<64 random hex chars>`.
  Later deploys without it reuse the stored value. Never put it in `samconfig.toml` (committed).
- Extra arguments are passed to `sam deploy` — preview only, without applying:
  `deploy\aws-lambda\deploy.cmd --no-execute-changeset`
- `sam build` is **not** used — the script already produces the deployable package.
  (`sam build` would try to build the project its own way, which doesn't fit the Web Adapter setup.)
- Every rebuild creates a "new" package (file timestamps inside the jar change), so even without code changes the
  changeset shows `Modify JavaViewFunction` + a new `Version`. That's harmless: it just republishes the same code.
  Only with an unchanged package does SAM report "No changes to deploy" (exit code 1, not an error).
- A deploy takes a few minutes: publishing a version makes SnapStart start Spring and take the snapshot.
- Check the template without deploying: `cd deploy\aws-lambda` then `sam validate --lint`.
- On Linux/macOS the same steps are: `./mvnw clean package`, copy the jar and `run.sh` into `target/lambda/`, `cd deploy/aws-lambda && sam deploy`.

## Finding the URL
The URL belongs to the **`live` alias**, not the base function, so it's not on the function's main page.
- Console: Lambda → Functions → `javaview-site` → **Aliases** tab → `live` → Function URL
- Console: CloudFormation → Stacks → `javaview-site` → **Outputs** → `SiteUrl`
- CLI: `sam list stack-outputs --stack-name javaview-site`
  or `aws lambda get-function-url-config --function-name javaview-site --qualifier live --region eu-south-1`

It stays the same across redeploys and changes only if the stack is deleted and recreated.
Don't add a second URL on the base function (`$LATEST`): it doesn't use SnapStart, so its cold starts are the full ~6.5 s.

## Logs
```
sam logs --stack-name javaview-site --tail
```

## Remove everything
```
sam delete
```
This deletes the `javaview-site` stack. The `aws-sam-cli-managed-default` stack / S3 bucket stays (shared by all SAM projects in the region).

## Measured after first deploy (Oct 16, 2026)
| | Time |
|---|---|
| Full Spring Boot init (only at deploy, while SnapStart builds the snapshot) | ~6.5 s |
| Cold start with SnapStart restore | ~0.75 s |
| Warm request (server side) | 5–70 ms |
| Memory used | ~190 MB of 1024 MB |

1024 MB is kept because Lambda CPU scales with memory (faster restore). Lowering to 512 MB would halve the cost per ms — test cold starts if you try it.

## Notes & gotchas
- **Read-only filesystem:** only `/tmp` is writable on Lambda. JTE must use **precompiled templates** (`prod` profile) — dev mode would try to write compiled classes to disk.
- **`run.sh` must use LF line endings and be executable.** `.gitattributes` forces LF; SAM CLI on Windows packaged it with the executable bit correctly (verified on first deploy).
- **SnapStart applies only to published versions**, which is why the template uses `AutoPublishAlias: live` and the Function URL points at the alias. Code that must be unique per instance (random seeds, IDs, open connections) shouldn't be created at startup — this site has none.
- **Custom domain:** Function URLs can't use your own domain. Put **CloudFront** in front (also caches `output.css` / favicons).
- **No rate limiting/WAF** on Function URLs — add CloudFront + WAF if the site ever gets abuse traffic.
- **Compression:** `AWS_LWA_ENABLE_COMPRESSION=true` lets the adapter gzip responses (home page 7.9 KB → 2.3 KB).
- **Cost:** Lambda free tier = 1M requests + 400,000 GB-s per month; Function URLs are free. SnapStart is free for Java. Expect ~$0 for a landing page.
- **Behind a proxy: `server.forward-headers-strategy: native`** (`application-prod.yml`). The Function URL and the
  Web Adapter hand Tomcat plain http from localhost. Without this setting redirects (login, logout, `/secured`) point to
  `http://…`, which Function URLs don't answer (they only serve https), and every visitor IP looks like `127.0.0.1`.
- **Log retention is 30 days** (`JavaViewLogGroup` in `template.yaml`), as promised on the site's `/privacy` page —
  change both together.
- **Build with the `prod` profile.** `spring.profiles.active` in `application.yml` is baked into the jar; a jar built
  with `dev` would try to compile templates at runtime and fail on Lambda.
- **Web Adapter layer version** (`LambdaAdapterLayerArm64:30`) is pinned in `template.yaml` — bump it when a new adapter release comes out.
- **SAM telemetry:** set `SAM_CLI_TELEMETRY=0` to opt out.

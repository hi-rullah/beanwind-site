# Deploying to Google Cloud Run

> **Status: reference only.** This is how the site was deployed until October 2026 (Java 17 / Spring Boot 3.2 at the time).
> It has **not** been re-tested since the upgrade to Java 25 / Spring Boot 4 — see [Java version](#java-version) below.
> The site currently runs on AWS Lambda: [`../aws-lambda/README.md`](../aws-lambda/README.md).

Cloud Run needs **no extra files** in this project: `gcloud run deploy --source .` builds a container from the source
with Google Cloud buildpacks (Maven, using the included `mvnw`) and runs the jar. The app is ready for it because of:

1. **Port handling** — `server.port: ${PORT:8080}` in `application-prod.yml` binds to the port Cloud Run injects.
2. **Profiles** — `application.yml` defaults to `dev`; the deployment selects `prod` (`application-prod.yml`) with the
   `SPRING_PROFILES_ACTIVE=prod` environment variable. `prod` also requires `AUTH_COOKIE_SECRET` (login cookie key).
3. **JTE precompilation** — templates are precompiled during the Maven build, so nothing is compiled at runtime.

## First deployment (Cloud Shell)

1. Clone the repository (it's private on GitHub, so Cloud Shell needs a GitHub token or SSH key):
   ```bash
   git clone https://github.com/hi-rullah/jarloom-site.git
   cd jarloom-site
   ```

2. Deploy:
   ```bash
   gcloud run deploy jarloom --source . --region us-central1 --allow-unauthenticated      --set-env-vars SPRING_PROFILES_ACTIVE=prod,AUTH_COOKIE_SECRET=$(openssl rand -hex 32)
   ```
   - `--source .` — build from source, no Dockerfile needed
   - `--allow-unauthenticated` — public site
   - `--set-env-vars` — only needed on the first deploy; later revisions keep the variables

## Redeployment

1. Make and push your changes on your machine (`git push` to GitHub).
2. In Cloud Shell:
   ```bash
   cd jarloom-site
   git pull
   gcloud run deploy jarloom --source . --region us-central1 --allow-unauthenticated
   ```

## Java version

The buildpacks pick a default Java version, which may be older than the project's Java 25.
If the build fails on the Java version, pin it with a build environment variable (not verified for Java 25):
```bash
gcloud run deploy jarloom --source . --region us-central1 --allow-unauthenticated \
  --set-build-env-vars GOOGLE_RUNTIME_VERSION=25
```

## History
- **April 22, 2026** — first deployment: added `${PORT:8080}`, profile-specific config, JTE precompilation.
  Source was hosted on Google Cloud Source Repositories (remote `google`); it moved to GitHub in October 2026.

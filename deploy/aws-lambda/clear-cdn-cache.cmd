@echo off
rem Clears the CloudFront cache after a deploy, so visitors get the new pages and files right away.
rem The distribution ID comes from the CLOUDFRONT_DISTRIBUTION_ID environment variable (it is not part of the
rem SAM stack, so it is not in this repo). Without the variable this script does nothing.
rem Run it yourself after executing a changeset that "deploy.cmd --no-execute-changeset" created.
setlocal

if "%CLOUDFRONT_DISTRIBUTION_ID%"=="" (
    echo CLOUDFRONT_DISTRIBUTION_ID is not set: CloudFront cache not cleared
    exit /b 0
)

aws cloudfront create-invalidation --distribution-id %CLOUDFRONT_DISTRIBUTION_ID% --paths "/*" ^
    --query "Invalidation.[Id,Status]" --output text || exit /b 1
echo CloudFront cache is being cleared (takes about a minute)

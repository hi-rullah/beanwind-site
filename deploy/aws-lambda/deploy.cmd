@echo off
rem Builds the AWS Lambda package (target\lambda = jar + run.sh), deploys it with SAM and clears the CloudFront cache.
rem Extra arguments go to "sam deploy", e.g.  deploy.cmd --no-execute-changeset  (preview only)
setlocal
cd /d "%~dp0..\.."

call .\mvnw.cmd -q clean package || exit /b 1

if exist target\lambda rmdir /s /q target\lambda
mkdir target\lambda
copy /y target\beanwind-site.jar target\lambda\ >nul || exit /b 1
copy /y deploy\aws-lambda\run.sh target\lambda\ >nul || exit /b 1
echo Lambda package ready in target\lambda

cd deploy\aws-lambda
call sam deploy %* || exit /b 1

rem A preview deploys nothing, so there is nothing to clear yet
echo %* | findstr /c:"--no-execute-changeset" >nul && exit /b 0
call "%~dp0clear-cdn-cache.cmd"

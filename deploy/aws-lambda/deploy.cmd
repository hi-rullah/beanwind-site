@echo off
rem Builds the AWS Lambda package (target\lambda = jar + run.sh) and deploys it with SAM.
rem Extra arguments go to "sam deploy", e.g.  deploy.cmd --no-execute-changeset  (preview only)
setlocal
cd /d "%~dp0..\.."

call .\mvnw.cmd -q clean package || exit /b 1

if exist target\lambda rmdir /s /q target\lambda
mkdir target\lambda
copy /y target\jarloom-site.jar target\lambda\ >nul || exit /b 1
copy /y deploy\aws-lambda\run.sh target\lambda\ >nul || exit /b 1
echo Lambda package ready in target\lambda

cd deploy\aws-lambda
sam deploy %*

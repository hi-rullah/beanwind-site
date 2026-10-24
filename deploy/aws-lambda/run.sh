#!/bin/sh
# Started by the AWS Lambda Web Adapter (AWS_LAMBDA_EXEC_WRAPPER=/opt/bootstrap).
# The adapter forwards Lambda events as plain HTTP requests to port 8080.
exec java -XX:+TieredCompilation -XX:TieredStopAtLevel=1 -jar "$LAMBDA_TASK_ROOT/jarloom-site.jar"

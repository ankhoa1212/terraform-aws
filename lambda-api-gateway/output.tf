# Output value definitions
output "lambda_bucket_name" {
  description = "Name of the S3 bucket used to store function code."

  value = aws_s3_bucket.lambda_bucket.id
}
#Used to define your Lambda function and related resources.
output "function_name" {
  description = "Name of the Lambda function."

  value = aws_lambda_function.hello.function_name
}

#The API Gateway stage will publish your API to a URL managed by AWS
output "base_url" {
  description = "Base URL for API Gateway stage."

  value = aws_apigatewayv2_stage.lambda.invoke_url
}
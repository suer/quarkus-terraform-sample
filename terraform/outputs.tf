output "lambda_function_name" {
  value = aws_lambda_function.this.function_name
}

output "lambda_function_arn" {
  value = aws_lambda_function.this.arn
}

output "lambda_role_arn" {
  value = aws_iam_role.lambda.arn
}

output "api_endpoint" {
  value = aws_apigatewayv2_stage.default.invoke_url
}

output "lambda_function_arn" {
  description = "Lambda function ARN"
  value       = aws_lambda_function.ec2_uptime_maestro.arn
}

output "lambda_function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.ec2_uptime_maestro.function_name
}

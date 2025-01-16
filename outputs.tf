output "lambda_function_arn" {
  description = "Lambda function ARN"
  value       = aws_lambda_function.ec2_scheduler.arn
}

output "lambda_function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.ec2_scheduler.function_name
}

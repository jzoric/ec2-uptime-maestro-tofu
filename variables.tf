variable "aws_region" {
  type = string
  description = "AWS region"
  default = "eu-central-1"
}

variable "binary_url" {
  description = "URL to download the Lambda function (ec2-maestro-uptime binary)"
  type        = string
}

variable "binary_sha256" {
  description = "SHA256 checksum of the binary"
  type        = string
}

variable "function_name" {
  description = "Name of the Lambda function"
  type        = string
  default     = "ec2-maestro-uptime"
}

variable "role_name" {
  description = "Name of the IAM role for the Lambda function"
  type        = string
  default     = "ec2_maestro_uptime_lambda_role"
}

variable "policy_name" {
  description = "Name of the IAM policy for the Lambda function"
  type        = string
  default     = "ec2_maestro_uptime_lambda_policy"
}

variable "timeout" {
  description = "Lambda function timeout in seconds"
  type        = number
  default     = 30
}

variable "memory_size" {
  description = "Lambda function memory size in MB"
  type        = number
  default     = 128
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "start_rule_name" {
  description = "Name of the EventBridge rule for starting instances"
  type        = string
  default     = "start-ec2-instances"
}

variable "stop_rule_name" {
  description = "Name of the EventBridge rule for stopping instances"
  type        = string
  default     = "stop-ec2-instances"
}

variable "start_schedule" {
  description = "Cron expression for the start schedule"
  type        = string
  default     = "cron(0 8 ? * MON-FRI *)" 
}

variable "stop_schedule" {
  description = "Cron expression for the stop schedule"
  type        = string
  default     = "cron(0 18 ? * MON-FRI *)"
}

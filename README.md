# EC2 uptime maestro module

This OpenTofu module creates a Lambda function that can manage EC2 instances (start/stop) based on a schedule.

## Features

- Creates IAM role and policy for Lambda function
- Downloads and packages a custom binary for the Lambda function
- Configures EventBridge rules for triggering the lambda function

## Usage

```hcl
module "ec2_uptime_maestro" {
  source = "git::https://github.com/jzoric/ec2-uptime-maestro-tofu?ref=v1.0.0"

  aws_region = "eu-central-1"

  binary_url    = "https://github.com/jzoric/ec2-uptime-maestro-lambda/releases/download/v1.0.0/bootstrap"
  binary_sha256 = "6579469e52ec933130f7fa8646c4780d29eceedb6cf51cc3d68f45540fc24389"

  start_schedule = "cron(0 8 ? * MON-FRI *)"
  stop_schedule  = "cron(0 18 ? * MON-FRI *)"

  tags = {
    Environment = "production"
    Project     = "ec2-uptime-management"
  }
}
```

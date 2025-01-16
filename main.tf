resource "aws_iam_role" "lambda_role" {
  name = var.role_name
  tags = var.tags

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_policy" {
  name = var.policy_name
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeInstances",
          "ec2:StartInstances",
          "ec2:StopInstances"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

resource "null_resource" "download_binary" {
  triggers = {
    binary_url = var.binary_url
    sha256     = var.binary_sha256
  }

  provisioner "local-exec" {
    command = <<EOT
      curl -L ${var.binary_url} -o ${path.module}/bootstrap
      echo "${var.binary_sha256}  ${path.module}/bootstrap" | sha256sum -c
      chmod +x ${path.module}/bootstrap
    EOT
  }
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/bootstrap"
  output_path = "${path.module}/function.zip"
  
  depends_on = [null_resource.download_binary]
}

resource "aws_lambda_function" "ec_uptime_maestro" {
  filename         = data.archive_file.lambda_zip.output_path 
  function_name    = var.function_name
  role            = aws_iam_role.lambda_role.arn
  handler         = "main"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  runtime         = "provided.al2" 
  timeout     = var.timeout 
  memory_size = var.memory_size
  tags = var.tags
}

resource "aws_cloudwatch_event_rule" "start_instances" {
 name                = var.start_rule_name
 description         = "Start EC2 instances on schedule"
 schedule_expression = var.start_schedule
 tags = var.tags

}

resource "aws_cloudwatch_event_rule" "stop_instances" {
 name                = var.stop_rule_name
 description         = "Stop EC2 instances on schedule"
 schedule_expression = var.stop_schedule
 tags = var.tags

}

resource "aws_cloudwatch_event_target" "start_lambda" {
 rule      = aws_cloudwatch_event_rule.start_instances.name
 target_id = "StartEC2Instances"
 arn       = aws_lambda_function.ec2_maestro_uptime.arn

 input = jsonencode({
   "detail-type" = "start"
 })
}

resource "aws_cloudwatch_event_target" "stop_lambda" {
 rule      = aws_cloudwatch_event_rule.stop_instances.name
 target_id = "StopEC2Instances"
 arn       = aws_lambda_function.ec2_maestro_uptime.arn

 input = jsonencode({
   "detail-type" = "stop"
 })
}

resource "aws_lambda_permission" "allow_eventbridge_start" {
 statement_id  = "AllowEventBridgeStart"
 action        = "lambda:InvokeFunction"
 function_name = aws_lambda_function.ec2_maestro_uptime.function_name
 principal     = "events.amazonaws.com"
 source_arn    = aws_cloudwatch_event_rule.start_instances.arn
}

resource "aws_lambda_permission" "allow_eventbridge_stop" {
 statement_id  = "AllowEventBridgeStop"
 action        = "lambda:InvokeFunction"
 function_name = aws_lambda_function.ec2_maestro_uptime.function_name
 principal     = "events.amazonaws.com"
 source_arn    = aws_cloudwatch_event_rule.stop_instances.arn
}

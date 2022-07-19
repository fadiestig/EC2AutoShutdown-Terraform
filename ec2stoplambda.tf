resource "aws_lambda_function" "ec2stop_lambda" {
  # If the file is not in the current working directory you will need to include a 
  # path.module in the filename.
  filename      = "stoplambda.zip"
  function_name = "ec2stop_lambda"
  role          = aws_iam_role.ec2stopstart-role.arn
  handler       = "stop_lambda_function.lambda_handler"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = filebase64sha256("stop_lambda_function.py")

  runtime = "python3.7"

  tracing_config {
    mode = "Active"
  }

}

resource "aws_cloudwatch_event_rule" "ec2stop_lambda_rule" {
  name                = "ec2stop_lambda-rule"
  schedule_expression = "cron(3 * * * ? *)" # every hour, 35 mns passed the hour
}

resource "aws_cloudwatch_event_target" "ec2stop_lambda_target" {
  rule = aws_cloudwatch_event_rule.ec2stop_lambda_rule.name
  arn  = aws_lambda_function.ec2stop_lambda.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_ec2stop_lambda" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ec2stop_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.ec2stop_lambda_rule.arn
}
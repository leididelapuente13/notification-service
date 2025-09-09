resource "aws_lambda_function" "send_notifications_lambda" {
  filename         = "${path.module}/notification-service.zip"
  function_name    = "send-notifications-lambda"
  role            = aws_iam_role.notification_lambda_role.arn
  handler         = "dist/index.sendNotificationsHandler"
  runtime         = "nodejs18.x"
  timeout         = 300
  memory_size     = 512
  source_code_hash = filebase64sha256("${path.module}/notification-service.zip")

  environment {
    variables = {
      NOTIFICATION_QUEUE_URL  = aws_sqs_queue.notification_email_sqs.url
      ERROR_QUEUE_URL        = aws_sqs_queue.notification_email_error_sqs.url
      NOTIFICATION_TABLE     = aws_dynamodb_table.notification_table.name
      ERROR_TABLE           = aws_dynamodb_table.notification_error_table.name
      TEMPLATES_BUCKET      = aws_s3_bucket.templates_email_notification.id
      FROM_EMAIL            = var.from_email
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.notification_lambda_policy_attachment,
    aws_cloudwatch_log_group.send_notifications_log_group
  ]

  tags = {
    Name        = "send-notifications-lambda"
    Environment = var.environment
    Service     = "notification"
  }
}

resource "aws_lambda_function" "send_notifications_error_lambda" {
  filename         = "${path.module}/notification-service.zip"
  function_name    = "send-notifications-error-lambda"
  role            = aws_iam_role.notification_lambda_role.arn
  handler         = "dist/index.sendNotificationsErrorHandler"
  runtime         = "nodejs18.x"
  timeout         = 300
  memory_size     = 256
  source_code_hash = filebase64sha256("${path.module}/notification-service.zip")

  environment {
    variables = {
      ERROR_TABLE = aws_dynamodb_table.notification_error_table.name
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.notification_lambda_policy_attachment,
    aws_cloudwatch_log_group.send_notifications_error_log_group
  ]

  tags = {
    Name        = "send-notifications-error-lambda"
    Environment = var.environment
    Service     = "notification"
  }
}

resource "aws_cloudwatch_log_group" "send_notifications_log_group" {
  name              = "/aws/lambda/send-notifications-lambda"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_group" "send_notifications_error_log_group" {
  name              = "/aws/lambda/send-notifications-error-lambda"
  retention_in_days = 14
}

resource "aws_lambda_event_source_mapping" "notification_sqs_trigger" {
  event_source_arn = aws_sqs_queue.notification_email_sqs.arn
  function_name    = aws_lambda_function.send_notifications_lambda.arn
  batch_size       = 10
  enabled          = true
}

resource "aws_lambda_event_source_mapping" "notification_error_sqs_trigger" {
  event_source_arn = aws_sqs_queue.notification_email_error_sqs.arn
  function_name    = aws_lambda_function.send_notifications_error_lambda.arn
  batch_size       = 5
  enabled          = true
}
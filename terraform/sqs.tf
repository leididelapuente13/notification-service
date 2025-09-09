resource "aws_sqs_queue" "notification_email_sqs" {
  name                      = "notification-email-sqs"
  delay_seconds             = 0
  max_message_size          = 262144
  message_retention_seconds = 1209600
  visibility_timeout_seconds = 360

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.notification_email_error_sqs.arn
    maxReceiveCount     = 3
  })

  tags = {
    Name        = "notification-email-sqs"
    Environment = var.environment
    Service     = "notification"
  }
}

resource "aws_sqs_queue" "notification_email_error_sqs" {
  name                      = "notification-email-error-sqs"
  delay_seconds             = 0
  max_message_size          = 262144
  message_retention_seconds = 1209600
  visibility_timeout_seconds = 360

  tags = {
    Name        = "notification-email-error-sqs"
    Environment = var.environment
    Service     = "notification"
  }
}

resource "aws_sqs_queue_policy" "notification_queue_policy" {
  queue_url = aws_sqs_queue.notification_email_sqs.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "*"
        }
        Action = [
          "sqs:SendMessage",
          "sqs:ReceiveMessage"
        ]
        Resource = aws_sqs_queue.notification_email_sqs.arn
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = data.aws_caller_identity.current.account_id
          }
        }
      }
    ]
  })
}
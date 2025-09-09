# IAM Role for Lambda functions
resource "aws_iam_role" "notification_lambda_role" {
  name = "${var.project_name}-notification-lambda-role-${var.environment}"

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

  tags = {
    Name        = "${var.project_name}-notification-lambda-role"
    Environment = var.environment
    Service     = "notification"
  }
}

# IAM Policy for Lambda functions
resource "aws_iam_policy" "notification_lambda_policy" {
  name        = "${var.project_name}-notification-lambda-policy-${var.environment}"
  description = "IAM policy for notification service Lambda functions"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:*"
      },
      {
        Effect = "Allow"
        Action = [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:SendMessage",
          "sqs:GetQueueAttributes"
        ]
        Resource = [
          aws_sqs_queue.notification_email_sqs.arn,
          aws_sqs_queue.notification_email_error_sqs.arn
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:UpdateItem",
          "dynamodb:Query"
        ]
        Resource = [
          aws_dynamodb_table.notification_table.arn,
          aws_dynamodb_table.notification_error_table.arn,
          "${aws_dynamodb_table.notification_table.arn}/index/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource = "${aws_s3_bucket.templates_email_notification.arn}/*"
      },
      {
        Effect = "Allow"
        Action = [
          "ses:SendEmail",
          "ses:SendRawEmail"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "notification_lambda_policy_attachment" {
  role       = aws_iam_role.notification_lambda_role.name
  policy_arn = aws_iam_policy.notification_lambda_policy.arn
}
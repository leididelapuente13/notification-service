output "notification_queue_url" {
  description = "URL of the notification SQS queue"
  value       = aws_sqs_queue.notification_email_sqs.url
}

output "error_queue_url" {
  description = "URL of the error SQS queue"  
  value       = aws_sqs_queue.notification_email_error_sqs.url
}

output "notification_table_name" {
  description = "Name of the notification DynamoDB table"
  value       = aws_dynamodb_table.notification_table.name
}

output "templates_bucket_name" {
  description = "Name of the templates S3 bucket"
  value       = aws_s3_bucket.templates_email_notification.id
}

output "lambda_function_names" {
  description = "Names of the Lambda functions"
  value = {
    send_notifications       = aws_lambda_function.send_notifications_lambda.function_name
    send_notifications_error = aws_lambda_function.send_notifications_error_lambda.function_name
  }
}

output "queue_urls_for_other_services" {
  description = "Queue URLs that other services will use to send notifications"
  value = {
    notification_queue = aws_sqs_queue.notification_email_sqs.url
    error_queue       = aws_sqs_queue.notification_email_error_sqs.url
  }
}
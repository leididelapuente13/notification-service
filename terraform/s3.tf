resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "templates_email_notification" {
  bucket = "templates-email-notification-${random_id.bucket_suffix.hex}"

  tags = {
    Name        = "templates-email-notification"
    Environment = var.environment
    Service     = "notification"
  }
}

resource "aws_s3_bucket_versioning" "templates_bucket_versioning" {
  bucket = aws_s3_bucket.templates_email_notification.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "templates_bucket_encryption" {
  bucket = aws_s3_bucket.templates_email_notification.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Upload all template files from local templates folder
resource "aws_s3_object" "welcome_template" {
  bucket       = aws_s3_bucket.templates_email_notification.id
  key          = "welcome.json"
  source       = "${path.module}/../templates/welcome.json"
  etag         = filemd5("${path.module}/../templates/welcome.json")
  content_type = "application/json"

  tags = {
    Name        = "welcome-template"
    Environment = var.environment
    Service     = "notification"
  }
}

resource "aws_s3_object" "user_login_template" {
  bucket       = aws_s3_bucket.templates_email_notification.id
  key          = "user.login.json"
  source       = "${path.module}/../templates/user.login.json"
  etag         = filemd5("${path.module}/../templates/user.login.json")
  content_type = "application/json"

  tags = {
    Name        = "user-login-template"
    Environment = var.environment
    Service     = "notification"
  }
}

resource "aws_s3_object" "user_update_template" {
  bucket       = aws_s3_bucket.templates_email_notification.id
  key          = "user.update.json"
  source       = "${path.module}/../templates/user.update.json"
  etag         = filemd5("${path.module}/../templates/user.update.json")
  content_type = "application/json"

  tags = {
    Name        = "user-update-template"
    Environment = var.environment
    Service     = "notification"
  }
}

resource "aws_s3_object" "card_create_template" {
  bucket       = aws_s3_bucket.templates_email_notification.id
  key          = "card.create.json"
  source       = "${path.module}/../templates/card.create.json"
  etag         = filemd5("${path.module}/../templates/card.create.json")
  content_type = "application/json"

  tags = {
    Name        = "card-create-template"
    Environment = var.environment
    Service     = "notification"
  }
}

resource "aws_s3_object" "card_activate_template" {
  bucket       = aws_s3_bucket.templates_email_notification.id
  key          = "card.activate.json"
  source       = "${path.module}/../templates/card.activate.json"
  etag         = filemd5("${path.module}/../templates/card.activate.json")
  content_type = "application/json"

  tags = {
    Name        = "card-activate-template"
    Environment = var.environment
    Service     = "notification"
  }
}

resource "aws_s3_object" "transaction_purchase_template" {
  bucket       = aws_s3_bucket.templates_email_notification.id
  key          = "transaction.purchase.json"
  source       = "${path.module}/../templates/transaction.purchase.json"
  etag         = filemd5("${path.module}/../templates/transaction.purchase.json")
  content_type = "application/json"

  tags = {
    Name        = "transaction-purchase-template"
    Environment = var.environment
    Service     = "notification"
  }
}

resource "aws_s3_object" "transaction_save_template" {
  bucket       = aws_s3_bucket.templates_email_notification.id
  key          = "transaction.save.json"
  source       = "${path.module}/../templates/transaction.save.json"
  etag         = filemd5("${path.module}/../templates/transaction.save.json")
  content_type = "application/json"

  tags = {
    Name        = "transaction-save-template"
    Environment = var.environment
    Service     = "notification"
  }
}

resource "aws_s3_object" "transaction_paid_template" {
  bucket       = aws_s3_bucket.templates_email_notification.id
  key          = "transaction.paid.json"
  source       = "${path.module}/../templates/transaction.paid.json"
  etag         = filemd5("${path.module}/../templates/transaction.paid.json")
  content_type = "application/json"

  tags = {
    Name        = "transaction-paid-template"
    Environment = var.environment
    Service     = "notification"
  }
}

resource "aws_s3_object" "report_activity_template" {
  bucket       = aws_s3_bucket.templates_email_notification.id
  key          = "report.activity.json"
  source       = "${path.module}/../templates/report.activity.json"
  etag         = filemd5("${path.module}/../templates/report.activity.json")
  content_type = "application/json"

  tags = {
    Name        = "report-activity-template"
    Environment = var.environment
    Service     = "notification"
  }
}
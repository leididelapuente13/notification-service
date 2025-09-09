# Main notification table
resource "aws_dynamodb_table" "notification_table" {
  name           = "notification-table"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "uuid"
  range_key      = "createdAt"

  attribute {
    name = "uuid"
    type = "S"
  }

  attribute {
    name = "createdAt"
    type = "S"
  }

  attribute {
    name = "type"
    type = "S"
  }

  global_secondary_index {
    name               = "TypeIndex"
    hash_key           = "type"
    range_key          = "createdAt"
    projection_type    = "ALL"
  }

  tags = {
    Name        = "notification-table"
    Environment = var.environment
    Service     = "notification"
  }
}

resource "aws_dynamodb_table" "notification_error_table" {
  name           = "notification-error-table"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "uuid"
  range_key      = "createdAt"

  attribute {
    name = "uuid"
    type = "S"
  }

  attribute {
    name = "createdAt"
    type = "S"
  }
}
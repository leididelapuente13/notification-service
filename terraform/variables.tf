variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "inferno-bank"
}

variable "from_email" {
  description = "Email address for sending notifications"
  type        = string
  default     = "leididelapuente3@gmail.com"
}
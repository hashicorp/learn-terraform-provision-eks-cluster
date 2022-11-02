variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}

variable "slack_app_token" {
  description = "Slack App Token"
  type        = string
}

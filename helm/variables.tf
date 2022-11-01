variable "region" {
  default = "us-east-2"
}

variable "application_name" {
  type    = string
  default = "terramino"
}

variable "slack_app_token" {
  type        = string
  description = "Slack App Token"
}


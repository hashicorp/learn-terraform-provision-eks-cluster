terraform {
  required_version = "~> 1.0"

  backend "s3" {
    bucket  = "learn-s3-remote-backend-20220922123852033500000001"
    key     = "terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
    acl     = "private"
  }
}
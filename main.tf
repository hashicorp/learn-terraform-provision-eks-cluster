provider "aws" {
  region = var.region
  default_tags {
    tags = {
      CATEGORY = "ENG_ASSESSMENT"
      OWNER    = "RIZZO_A"
    }
  }
}

# Filter out local zones, which are not currently supported  with managed node groups
data "aws_availability_zones" "available" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

locals {
  cluster_name    = "rizzo"
  cluster_version = "1.27"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}
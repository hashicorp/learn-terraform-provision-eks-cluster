# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "deploymentPrefix" {
  description = "Prefix for resources that if their are multiple deployments that need to be differentiated"
  type        = string
  default     = "client-a"
}
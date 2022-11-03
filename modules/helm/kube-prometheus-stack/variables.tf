variable "namespace" {
  description = "Namespace to deploy the application"
  type        = string
  default     = "monitoring"
}

variable "chart_version" {
  description = "Chart version"
  type        = string
  default     = "15.4.4"
}

variable "cluster_id" {
  description = "EKS cluster ID"
  type        = string
}

variable helm_version {
  description = "The version of the chart to deploy"
  type        = string
  default     = "34.1.1"
}

variable verify {
  description = "Verify the package before installing it"
  type        = bool
  default     = false
}

variable namespace {
  description = "The namespace to deploy the chart into"
  type        = string
  default     = "monitoring"
}

variable chart_name {
  description = "The name of the chart to deploy"
  type        = string
  default     = "kube-prometheus-stack"
}

variable helm_values {
  description = "The values to pass to the helm chart"
  type        = string
  default     = ""
}
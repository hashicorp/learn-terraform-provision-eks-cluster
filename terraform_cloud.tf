terraform {
  cloud {
    organization = "vigneshragupathy"

    workspaces {
      name = "terraform-eks-prometheus-thanos"
    }
  }
}
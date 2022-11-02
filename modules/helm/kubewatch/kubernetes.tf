/*provider "aws" {
  region = var.region
}*/

/*data "terraform_remote_state" "eks" {
  backend = "local"
  config = {
    path = "../learn-terraform-provision-eks-cluster/terraform.tfstate"
  }
}*/

# Terraform remote state for backend remote/cloud
/*data "terraform_remote_state" "eks" {
  backend = "remote"
  config = {
    organization = "vigneshragupathy"

    workspaces = {
      name = "learn-terraform-provision-eks-cluster"
    }
  }
}

# Retrieve EKS cluster configuration
data "aws_eks_cluster" "cluster" {
  name = data.terraform_remote_state.eks.outputs.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = data.terraform_remote_state.eks.outputs.cluster_id
}*/

/*provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.cluster.name]
    command     = "aws"
  }
}*/

data "aws_eks_cluster" "cluster" {
  name = output.cluster_id
}

resource "kubernetes_namespace" "terramino" {
  metadata {
    name = "terramino"
  }
}

resource "kubernetes_deployment" "terramino" {
  metadata {
    name      = var.application_name
    namespace = kubernetes_namespace.terramino.id
    labels = {
      app = var.application_name
    }
  }

  spec {
    replicas = 3
    selector {
      match_labels = {
        app = var.application_name
      }
    }
    template {
      metadata {
        labels = {
          app = var.application_name
        }
      }
      spec {
        container {
          image = "tr0njavolta/terramino"
          name  = var.application_name
        }
      }
    }
  }
}

resource "kubernetes_service" "terramino" {
  metadata {
    name      = var.application_name
    namespace = kubernetes_namespace.terramino.id
  }
  spec {
    selector = {
      app = kubernetes_deployment.terramino.metadata[0].labels.app
    }
    port {
      port        = 8080
      target_port = 80
    }
    type = "LoadBalancer"
  }
}

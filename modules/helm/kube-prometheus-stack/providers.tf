/*data "terraform_remote_state" "eks" {
  backend = "local"
  config = {
    path = "../learn-terraform-provision-eks-cluster/terraform.tfstate"
  }
}*/

# Terraform remote state for backend remote/cloud
data "tfe_outputs" "remote_state" {
  organization = "vigneshragupathy"
  workspace    = "terraform-eks-prometheus-thanos"
}

# Retrieve EKS cluster configuration
data "aws_eks_cluster" "cluster" {
  name = data.tfe_outputs.remote_state.values.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = data.tfe_outputs.remote_state.values.cluster_id
}

/*provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.cluster.name]
    command     = "aws"
  }
}*/
provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.cluster.name]
      command     = "aws"
    }
  }
}

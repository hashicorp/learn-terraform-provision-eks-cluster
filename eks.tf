# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group#tracking-the-latest-eks-node-group-ami-releases
data "aws_ssm_parameter" "eks_ami_release_version" {
  name = "/aws/service/eks/optimized-ami/${local.cluster_version}/amazon-linux-2/recommended/release_version"
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.15.3"

  cluster_name    = local.cluster_name
  cluster_version = local.cluster_version

  vpc_id                               = module.vpc.vpc_id
  subnet_ids                           = module.vpc.private_subnets
  cluster_endpoint_public_access       = true
  cluster_endpoint_public_access_cidrs = ["196.182.32.48/32", "0.0.0.0/0"] # Cannot create a name space w/o opening the cluster to the world

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"
  }

  eks_managed_node_groups = {
    one = {
      name = "${local.cluster_name}-node-group-1"

      instance_types = ["t3.small"] //c5.large - reset 
      release_version = nonsensitive(data.aws_ssm_parameter.eks_ami_release_version.value)

      min_size     = 1 //3 - reset
      max_size     = 1 //6 - reset
      desired_size = 1 //3 - reset 
    }
  }
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", local.cluster_name]
  }
}

resource "kubernetes_namespace" "rizzo" {
  metadata {
    name = "rizzo"
  }
}

module "iam_eks_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-eks-role"

  role_name = "${local.cluster_name}-cluster"

  cluster_service_accounts = {
    "${local.cluster_name}" = ["default:${local.cluster_name}-serviceaccount"]
  }

  depends_on = [module.eks.cluster_name]
}

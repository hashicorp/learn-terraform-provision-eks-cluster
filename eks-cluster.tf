module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "18.0.4"
  cluster_name    = local.cluster_name
  cluster_version = "1.20"
  subnet_ids      = module.vpc.private_subnets

  tags = {
    Environment = "training"
    GithubRepo  = "terraform-aws-eks"
    GithubOrg   = "terraform-aws-modules"
  }

  vpc_id = module.vpc.vpc_id

  self_managed_node_group_defaults = {
    instance_type    = "t2.small"
    root_volume_type = "gp2"
  }

  self_managed_node_groups = {
    worker-group-1 = {
      instance_type                 = "t2.small"
      pre_bootstrap_user_data       = "echo foo bar"
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_one.id]
      min_size                      = 1
      max_size                      = 5
      desired_size                  = 2
    },
    worker-group-2 = {
      instance_type                 = "t2.medium"
      pre_bootstrap_user_data       = "echo foo bar"
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_two.id]
      min_size                      = 1
      max_size                      = 5
      desired_size                  = 1
    },
  }
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

# Intro
This repo has been modified from its original intention, [Learn Terraform - Provision an EKS Cluster](https://github.com/hashicorp/learn-terraform-provision-eks-cluster) to update the settings of said [EKS Cluster](https://docs.aws.amazon.com/eks/latest/userguide/clusters.html) to meet the specifications of the following [document](https://docs.google.com/document/d/1KazQNCVxanZgx8knxft3DLUW-brfmDVK/edit?usp=sharing&ouid=102029265654967067334&rtpof=true&sd=true). This EKS cluster is not meant for production use and is built for educational purposes only.

## Getting Started

### Prerequisites
- [Terraform v1.5.7](https://developer.hashicorp.com/terraform/downloads)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- [Kubectl](https://kubernetes.io/docs/tasks/tools)
- [Kubeps1](https://github.com/jonmosco/kube-ps1) - Not require but highly recommended 


# Getting Started
After cloning the repo ensure you have an AWS configured with the account you wish to deploy this EKS cluster. 
This account must be an IAM account with all of the appropriate permissions, it doesn't work using a root account.

To get this started you can grant this IAM user full permissions, but in production it is HIGHLY recommended you maintain the [principle of least privilege](https://en.wikipedia.org/wiki/Principle_of_least_privilege)

This project is setup using terraform workspaces. We have two environments, dev and prod. Prod is only to be used by CI/CD pipeline. To get started with the dev environment select the dev workspace by running the following command

```bash
 $ terraform workspace select dev
```

Initialize the Terraform project.
```bash
 $ terraform init
```

Initialize the Terraform project.
```bash
 $ terraform apply
```

Once complete you must configure kubectl
```bash
aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name)
```

Then lastly verify your cluster

```bash
kubectl cluster-info
```

You should see roughly the following output
```bash
Kubernetes control plane is running at https://5AB8C9482D4F766B32E18BBF7A1CF8FF.gr7.us-west-2.eks.amazonaws.com
CoreDNS is running at https://5AB8C9482D4F766B32E18BBF7A1CF8FF.gr7.us-west-2.eks.amazonaws.com/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
```


- TODO Finish tutorial
    - Research Service role --
    - Add public ingress and nginx hello world
    - Profit

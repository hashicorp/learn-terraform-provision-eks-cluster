#!/bin/bash

#Install tfswitch and set version Terraform 0.13.5 
curl -L https://raw.githubusercontent.com/warrensbox/terraform-switcher/release/install.sh | bash
tfswitch 0.13.5
export GOROOT=/usr/local/go
export GOPATH=$HOME/Projects/Proj1
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
/bin/bash -c 'source ~/.bashrc'
git clone https://github.com/apparentlymart/terraform-clean-syntax.git
tffolder=terraform-clean-syntax
cmdtf="cd"
$cmdtf $tffolder
go get .
terraform-clean-syntax .

#Scripts Terraform create cluster EKS


#Check kubectl exist and install if necessary
if ! command -v kubectl &> /dev/null
then
    echo ">>>> kubectl could not be found !!!"
    curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x ./kubectl
    sudo mv ./kubectl /usr/local/bin/kubectl
    kubectl version --client
else
    echo "> kubectl was found !!"
    kubectl version --client
    exit
fi

#Get kubeconfig AWS EKS Cluster
aws eks --region "$(terraform output region)" update-kubeconfig --name "$(terraform output cluster_name)"

#Deploy Kubernetes Metrics Server
wget -O v0.3.6.tar.gz https://codeload.github.com/kubernetes-sigs/metrics-server/tar.gz/v0.3.6 && tar -xzf v0.3.6.tar.gz

#Deploy the metrics server to the cluster by running the following command.
kubectl apply -f metrics-server-0.3.6/deploy/1.8+/

#Verify that the metrics server has been deployed. If successful, you should see something like this.
kubectl get deployment metrics-server -n kube-system

#Deploy Kubernetes Dashboard
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta8/aio/deploy/recommended.yaml

#Create proxy server
kubectl proxy

#Authenticate dashboard
kubectl -n kube-system describe secret "$(kubectl -n kube-system get secret | grep service-controller-token | awk '{print $1}')"


#!/bin/bash
cat << END
Description : This Script is for github self-hosted runner.
Usage       : For AWS EKS, Install kubectl, eksctl, helm, terraform
OS          : ubuntu 18.4 LTS
VERSION     : awscli : 2.0.30, Python : 3.7.3, kubectl client : 1.21.2, server version : 1.22.9, eksctl : 0.100.0, helm : 3.8.2
Author      : "sangwon lee" <lee2155507@gmail.com>
END

echo "========================== kubectl install =========================="
curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/linux/amd64/kubectl
chmod +x ./kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin

echo "check"
kubectl version --short --client
sleep 5
echo "========================== eksctl install =========================="
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp

sudo mv /tmp/eksctl /usr/local/bin
echo "check"
sleep 5
eksctl version

echo "========================== Helm install =========================="
curl -L https://git.io/get_helm.sh | bash -s -- --version v3.8.2

# helm version 3.9 install issue cert-manager

echo "check"
sleep 5
helm

# echo  "========================== terraform install =========================="
# curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
# sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
# sudo apt-get update && sudo apt-get install terraform

echo "========================== Helm cert-manager install =========================="
helm repo add jetstack https://charts.jetstack.io
helm repo update

helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.8.0

echo "========================== Helm ARC =========================="
sleep 10

helm repo add actions-runner-controller https://actions-runner-controller.github.io/actions-runner-controller
helm upgrade --install --namespace actions-runner-system --create-namespace --wait actions-runner-controller actions-runner-controller/actions-runner-controller

echo "========================== Using PAT Authentication =========================="
# kubectl create secret generic controller-manager -n actions-runner-system --from-literal=github_token=${GITHUB_TOKEN}
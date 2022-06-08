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
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.8.0/cert-manager.crds.yaml
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


# 1. Get the application URL by running these commands:
#   export POD_NAME=$(kubectl get pods --namespace actions-runner-system -l "app.kubernetes.io/name=actions-runner-controller,app.kubernetes.io/instance=actions-runner-controller" -o jsonpath="{.items[0].metadata.name}")
#   export CONTAINER_PORT=$(kubectl get pod --namespace actions-runner-system $POD_NAME -o jsonpath="{.spec.containers[0].ports[0].containerPort}")
#   echo "Visit http://127.0.0.1:8080 to use your application"
#   kubectl --namespace actions-runner-system port-forward $POD_NAME 8080:$CONTAINER_PORT

echo "========================== Using Github APP Authentication =========================="
# kubectl create secret generic controller-manager \
#     -n actions-runner-system \
#     --from-literal=github_app_id=${APP_ID} \
#     --from-literal=github_app_installation_id=${INSTALLATION_ID} \
#     --from-file=github_app_private_key=${PRIVATE_KEY_FILE_PATH}
    

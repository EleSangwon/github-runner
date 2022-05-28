# github-runner

## Installation

```
1. SetUp Github PAT
2. Install cert-manager
3. Install action-runner-controller (ARC)
```

```
[ PAT ]

[ cert-manager ]
# Install Chart Using Helm
helm repo add jetstack https://charts.jetstack.io

helm repo update

# Install CRDs
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.8.0/cert-manager.crds.yaml

## Install cert-manager
helm install --wait \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.8.0 \
  --set installCRDs=true
or
kubectl create ns cert-manager
helm install my-release --namespace cert-manager --version v1.8.0 jetstack/cert-manager

# Verify installation
kubectl --namespace cert-manager get all

[ Deploy helm github runner ]
helm repo add actions-runner-controller https://actions-runner-controller.github.io/actions-runner-controller
helm upgrade --install --namespace actions-runner-system --create-namespace --wait actions-runner-controller actions-runner-controller/actions-runner-controller

kubectl create secret generic controller-manager -n actions-runner-system --from-literal=github_token=${GITHUB_TOKEN}
```
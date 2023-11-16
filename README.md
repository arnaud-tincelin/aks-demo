# AKS-Demo Repository

Exposes a weather forecast api through an ingress (AGIC)

## Demo Scenario

1. Deploy infrastructure with terraform
    - Network design (VNET, Subnets)
    - Node pools design
    - ACR
    - AKS: enable workload identity, Entra ID integration (RBAC), AGIC addon, CSI Secret store addon
1. How to deploy `weatherforecast` app in Kubernetes (in default namespace)
    - Kubectl CLI
    - Build & push Docker Image to ACR
1. `howtoaks` Application overview
    - AGIC presentation
    - CSI Secret store presentation
    - Presentation of the Kube manifest / Helm chart
    - Deploy Helm chart
1. Network policies

## Deploy Infrastructure

pre-requisites:

- [Az cli](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) is installed
- [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) is installed

```bash
az login
cd terraform
terraform init
terraform apply --auto-approve
```

## Publish & Deploy Helm Chart

pre-requisites:

- `GitHub Pages` has been configured on main/docs (in `Settings`)
- cluster's kubeconfig file has been retrievied
- [Helm](https://helm.sh/docs/intro/install/) is installed

```bash
cd charts
helm create howtoaks
helm lint .
cd ../docs
helm package ../charts/howtoaks
cd ..
helm repo index docs --url https://arnaud-tincelin.github.io/aks-demo
helm repo add aks-demo https://arnaud-tincelin.github.io/aks-demo
# helm install test aks-demo/howtoaks
```

## Test Network policies

```bash
KUBECONFIG=kubeconfig kubectl -n howtoaks run -i --tty busybox --image=busybox:1.28 -- sh
wget myapp-howtoaks-front.howtoaks:8080/
wget myapp-howtoaks-api.howtoaks:8081/weatherforecast
```

## Use Kubernetes role-based access control with Microsoft Entra ID in Azure Kubernetes Service

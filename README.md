# AKS-Demo Repository

Exposes a weather forecast api through an ingress (AGIC)

## Demo Scenario

1. Deploy infrastructure with terraform
  - Network design (VNET, Subnets)
  - Node pools design
  - ACR
  - AKS: enable workload identity, Entra ID integration (RBAC), AGIC addon, CSI Secret store addon
1. How to deploy sample app in Kubernetes (in default / named namespaces)
  - Kubectl CLI
1. Application overview
1. AGIC presentation
1. CSI Secret store presentation
1. Build & push Docker Image to ACR
1. Presentation of the Kube manifest / Helm chart
1. Deploy Helm chart
1. Network policies

```sh
az login
cd terraform
terraform init
terraform apply --auto-approve
```

## Helm Chart

```bash
cd charts
helm create weatherforecast
helm lint .
```

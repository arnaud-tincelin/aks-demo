# AKS-Demo Repository

Exposes a weather forecast api through an ingress (AGIC)

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

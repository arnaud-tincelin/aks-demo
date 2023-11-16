# AKS-Demo Repository

Exposes a weather forecast api and a howtoaks app through an ingress (AGIC)

## Demonstrated Features

1. AKS deployment through IaC (terraform)
1. ACR Build tasks
1. Deploy basic app using a kubernetes manifest (weatherforecast)
1. AGIC integration (weatherforecast)
1. Helm Charts packaging (howtoaks)
1. CSI Secret Store and Workload Identity (howtoaks)
1. Azure Network Policies
1. Entra ID integration (RBAC)

## Deploy Infrastructure

pre-requisites:

- [Az cli](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) is installed
- [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) is installed
- [kubectl](https://kubernetes.io/docs/tasks/tools/) is installed

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
# helm repo add aks-demo https://arnaud-tincelin.github.io/aks-demo
# helm install test aks-demo/howtoaks
```

## Test Network policies

```bash
KUBECONFIG=kubeconfig kubectl -n howtoaks run -i --tty busybox --image=busybox:1.28 -- sh
wget myapp-howtoaks-front.howtoaks:8080/Home/Index
wget myapp-howtoaks-api.howtoaks:8081/weatherforecast
```

## Use Kubernetes role-based access control with Microsoft Entra ID in Azure Kubernetes Service

1. Create `achat` namespace
1. Add a pod to `achat` namespace => `kubectl run nginx-dev --image=mcr.microsoft.com/oss/nginx/nginx:1.15.5-alpine --namespace achat`
1. Check pods in `achat` namespace and `howtoaks` namespace
1. Create Entra ID group `achat`
1. Add a user to `achat` Entra ID group
1. Create Role & apply

```yaml
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: achat-user-full-access
  namespace: achat
rules:
- apiGroups: ["", "extensions", "apps"]
  resources: ["*"]
  verbs: ["*"]
- apiGroups: ["batch"]
  resources:
  - jobs
  - cronjobs
  verbs: ["*"]
```

1. Create Role Binding & apply

```yaml
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: achat-user-access
  namespace: achat
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: achat-user-full-access
subjects:
- kind: Group
  namespace: achat
  name: groupObjectId
```

1. Test:

```bash
# Using user's identity added to the `achat` group above
az aks get-credentials --resource-group aks-demo --name aks-demo --overwrite-existing
kubectl get pods --namespace achat
kubectl get pods --all-namespaces
```

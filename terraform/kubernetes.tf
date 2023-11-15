resource "kubernetes_namespace" "howtoaks" {
  metadata {
    name = "howtoaks"
  }
}

resource "helm_release" "howtoaks" {
  name       = "myapp"
  repository = "https://arnaud-tincelin.github.io/aks-demo"
  chart      = "howtoaks"
  namespace  = kubernetes_namespace.howtoaks.metadata[0].name
  set {
    name  = "api.serviceAccount.name"
    value = "howtoaks"
  }
  set {
    name  = "api.image.repository"
    value = "${azurerm_container_registry.this.login_server}/howtoaks/api"
  }
  set {
    name  = "api.image.tag"
    value = "latest"
  }
  set {
    name  = "frontend.image.repository"
    value = "${azurerm_container_registry.this.login_server}/howtoaks/frontend"
  }
  set {
    name  = "frontend.image.tag"
    value = "latest"
  }
}

resource "terraform_data" "weatherforecast_deployment" {
  provisioner "local-exec" {
    command = "KUBECONFIG=${local_file.kubeconfig.filename} kubectl apply -f manifest.yaml"
    working_dir = abspath("${path.module}/../weatherforecast")
  }
}

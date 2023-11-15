resource "kubernetes_namespace" "weatherforecast" {
  metadata {
    name = "weatherforecast"
  }
}

# resource "kubernetes_service_account" "myapp" {
#   metadata {
#     name      = "myapp"
#     namespace = kubernetes_namespace.myapp.metadata[0].name
#   }
# }

resource "helm_release" "weatherforecast" {
  name       = "test"
  repository = "https://arnaud-tincelin.github.io/aks-demo"
  chart      = "weatherforecast"
  namespace  = kubernetes_namespace.weatherforecast.metadata[0].name
  set {
    name  = "serviceAccount.name"
    value = "mytestsa"
  }
  set {
    name  = "image.repository"
    value = "${azurerm_container_registry.this.login_server}/myapp/workload"
  }
  set {
    name  = "image.tag"
    value = "latest"
  }
}

# resource "terraform_data" "app_manifest_deployment" {
#   provisioner "local-exec" {
#     command = <<EOT
# cat <<EOF | KUBECONFIG=${local_file.kubeconfig.filename} kubectl apply -f -
# ${templatefile("${path.module}/../weatherforecast/manifest.yaml", {
#   namespace_name       = kubernetes_namespace.myapp.metadata[0].name
#   service_account_name = kubernetes_service_account.myapp.metadata[0].name
#   myapp_image          = "${azurerm_container_registry.this.login_server}/myapp/workload:latest"
# })}
# EOF
# EOT
#   }
# }

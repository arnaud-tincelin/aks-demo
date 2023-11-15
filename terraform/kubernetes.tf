resource "kubernetes_namespace" "myapp" {
  metadata {
    name = "myapp"
  }
}

resource "kubernetes_service_account" "myapp" {
  metadata {
    name      = "myapp"
    namespace = kubernetes_namespace.myapp.metadata[0].name
  }
}

# resource "helm_release" "S3" {
#   name             = "S3"
#   repository       = "s3://tf-test-helm-repo/charts"
#   chart            = "chart"
#   namespace = kubernetes_namespace.myapp.metadata[0].name
# }

resource "terraform_data" "app_manifest_deployment" {
  provisioner "local-exec" {
    command = <<EOT
cat <<EOF | KUBECONFIG=${local_file.kubeconfig.filename} kubectl apply -f -
${templatefile("${path.module}/../weatherforecast/manifest.yaml", {
  namespace_name       = kubernetes_namespace.myapp.metadata[0].name
  service_account_name = kubernetes_service_account.myapp.metadata[0].name
  myapp_image          = "${azurerm_container_registry.this.login_server}/myapp/workload:latest"
})}
EOF
EOT
  }
}

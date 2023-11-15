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
  values = [
    templatefile("${path.module}/howtoaks.yaml", {
      api_image                = "${azurerm_container_registry.this.login_server}/howtoaks/api"
      api_image_tag            = "latest"
      api_service_account_name = "howtoaks"
      frontend_image           = "${azurerm_container_registry.this.login_server}/howtoaks/frontend"
      frontend_image_tag       = "latest"
      csi_client_id            = azurerm_user_assigned_identity.howtoaks.client_id
      csi_tenant_id            = data.azurerm_client_config.current.tenant_id
      csi_vault_name           = azurerm_key_vault.this.name
      csi_secrets = [
        {
          name    = azurerm_key_vault_secret.my_secret.name
          type    = "secret"
          version = azurerm_key_vault_secret.my_secret.version
        }
      ]
    })
  ]
}

resource "terraform_data" "weatherforecast_deployment" {
  provisioner "local-exec" {
    command = "KUBECONFIG=${local_file.kubeconfig.filename} kubectl apply -f ${path.module}/../weatherforecast/manifest.yaml"
  }
}

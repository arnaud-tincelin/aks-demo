resource "azurerm_user_assigned_identity" "howtoaks" {
  name                = "howtoaks"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_role_assignment" "howtoaks_secret_officer" {
  principal_id         = azurerm_user_assigned_identity.howtoaks.principal_id
  role_definition_name = "Key Vault Secrets Officer"
  scope                = azurerm_key_vault.this.id
}

resource "azurerm_federated_identity_credential" "howtoaks" {
  name                = "howtoaks"
  parent_id           = azurerm_user_assigned_identity.howtoaks.id
  resource_group_name = azurerm_resource_group.this.name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = azurerm_kubernetes_cluster.this.oidc_issuer_url
  subject             = "system:serviceaccount:${kubernetes_namespace.howtoaks.metadata[0].name}:howtoaks"

  depends_on = [helm_release.howtoaks]
}

resource "kubernetes_namespace" "howtoaks" {
  metadata {
    name = "howtoaks"
  }
}

resource "helm_release" "howtoaks" {
  name       = "myapp"
  repository = "https://arnaud-tincelin.github.io/aks-demo"
  chart      = "howtoaks"
  version    = "1.0.9"
  namespace  = kubernetes_namespace.howtoaks.metadata[0].name
  values = [
    templatefile("${path.module}/howtoaks.yaml", {
      api_image            = "${azurerm_container_registry.this.login_server}/howtoaks/api"
      api_image_tag        = "latest"
      frontend_image       = "${azurerm_container_registry.this.login_server}/howtoaks/frontend"
      frontend_image_tag   = "latest"
      service_account_name = "howtoaks"
      csi_client_id        = azurerm_user_assigned_identity.howtoaks.client_id
      csi_tenant_id        = data.azurerm_client_config.current.tenant_id
      csi_vault_name       = azurerm_key_vault.this.name
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

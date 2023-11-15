data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "this" {
  name                      = "atiaksdemo"
  location                  = azurerm_resource_group.this.location
  resource_group_name       = azurerm_resource_group.this.name
  tenant_id                 = data.azurerm_client_config.current.tenant_id
  sku_name                  = "standard"
  enable_rbac_authorization = true
}

resource "azurerm_role_assignment" "current_user_vault_administrator" {
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_key_vault_secret" "my_secret" {
  name         = "my-secret"
  value        = "my-secret-value"
  key_vault_id = azurerm_key_vault.this.id

  depends_on = [ azurerm_role_assignment.current_user_vault_administrator ]
}

resource "azurerm_container_registry" "this" {
  name                = "atiaksdemo"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  sku                 = "Basic"
}

resource "terraform_data" "acr_build" {
  triggers_replace = tomap({
    "registry" = azurerm_container_registry.this.name
  })

  provisioner "local-exec" {
    command     = "az acr build --registry ${self.triggers_replace["registry"]} --image myapp/workload:latest --platform linux ."
    working_dir = abspath("${path.module}/../weatherforecast")
  }
}

resource "azurerm_container_registry" "this" {
  name                = "atiaksdemo"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  sku                 = "Basic"
}

resource "terraform_data" "acr_build_weatherforecast" {
  triggers_replace = tomap({
    "registry" = azurerm_container_registry.this.name
  })

  provisioner "local-exec" {
    command     = "az acr build --registry ${self.triggers_replace["registry"]} --image weatherforecast/api:latest --platform linux ."
    working_dir = abspath("${path.module}/../weatherforecast")
  }
}

resource "terraform_data" "acr_build_howtoaks_api" {
  triggers_replace = tomap({
    "registry" = azurerm_container_registry.this.name
  })

  provisioner "local-exec" {
    command     = "az acr build --registry ${self.triggers_replace["registry"]} --image howtoaks/api:latest --platform linux ."
    working_dir = abspath("${path.module}/../howtoaks/HowToAKS.WebApi")
  }
}

resource "terraform_data" "acr_build_howtoaks_frontend" {
  triggers_replace = tomap({
    "registry" = azurerm_container_registry.this.name
  })

  provisioner "local-exec" {
    command     = "az acr build --registry ${self.triggers_replace["registry"]} --image howtoaks/frontend:latest --platform linux ."
    working_dir = abspath("${path.module}/../howtoaks/HowToAKS.Web")
  }
}

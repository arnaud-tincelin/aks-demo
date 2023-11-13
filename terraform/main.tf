resource "azurerm_resource_group" "this" {
  name     = "aks-demo"
  location = "West Europe"
}

resource "azurerm_virtual_network" "this" {
  name                = "aks-demo"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = ["192.168.0.0/23"]

}

resource "azurerm_subnet" "nodes" {
  name                 = "aks-nodes"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["192.168.0.0/24"]
}

resource "azurerm_subnet" "gateway" {
  name                 = "aks-gateway"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["192.168.1.0/24"]
}

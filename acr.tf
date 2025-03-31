resource "azurerm_container_registry" "acr" {
  name                = "gridacr1246213"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  sku                 = "Standard"
  admin_enabled       = false

}
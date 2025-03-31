resource "azurerm_user_assigned_identity" "base_networking" {
  location            = azurerm_resource_group.this.location
  name                = "base_networking"
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_role_assignment" "networking" {
  scope                = azurerm_resource_group.this.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.base_networking.principal_id
}

resource "azurerm_role_assignment" "acr" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.base_networking.principal_id
  depends_on           = [azurerm_container_registry.acr]
}
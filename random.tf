resource "azurerm_resource_group" "example" {
  name     = "exampleresourccc"
  location = "East US"
}

resource "azurerm_storage_account" "example" {
  name                     = "examplestrggg"
  resource_group_name       = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier              = "Standard"
  account_replication_type = "LRS"
}
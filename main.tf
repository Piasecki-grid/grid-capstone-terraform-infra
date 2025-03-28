# providers.tf
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstatestorageaccount25"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

# variables.tf
variable "location" {
  description = "Azure region"
  type        = string
  default     = "eastus"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "my-terraform-rg"
}

# main.tf
resource "azurerm_resource_group" "example" {
  name     = "${var.resource_group_name}-${var.environment}"
  location = var.location
}

resource "azurerm_storage_account" "example" {
  name                     = "mystorageaccount${var.environment}"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# outputs.tf
output "resource_group_name" {
  value = azurerm_resource_group.example.name
}

output "storage_account_name" {
  value = azurerm_storage_account.example.name
}
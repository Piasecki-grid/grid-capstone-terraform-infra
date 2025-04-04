provider "azurerm" {
  features {}
}

# provider "helm" {
#   kubernetes {
#     host                   = data.azurerm_kubernetes_cluster.this.kube_config.0.host
#     client_certificate     = base64decode(data.azurerm_kubernetes_cluster.this.kube_config.0.client_certificate)
#     client_key             = base64decode(data.azurerm_kubernetes_cluster.this.kube_config.0.client_key)
#     cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.this.kube_config.0.cluster_ca_certificate)
#   }
# }
provider "azapi" {
  use_msi = false
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = "~>1.5"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.9.1"
    }
  }

  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstatestorageaccount25"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
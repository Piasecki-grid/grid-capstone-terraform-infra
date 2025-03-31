resource "azuread_group" "cluster_admins" {
  security_enabled = true
  display_name     = "AKS Cluster Administrators"

}

resource "azuread_group" "cluster_developers" {
  security_enabled = true
  display_name     = "AKS Cluster Developers"

}

resource "azurerm_role_assignment" "aks_developer_role" {
  scope                = azurerm_kubernetes_cluster.this.id
  role_definition_name = "Azure Kubernetes Service Cluster User Role"
  principal_id         = azuread_group.cluster_developers.object_id
}


resource "azurerm_role_assignment" "aks_admin_role" {
  scope                = azurerm_kubernetes_cluster.this.id
  role_definition_name = "Azure Kubernetes Service Cluster Admin Role"
  principal_id         = azuread_group.cluster_admins.object_id
}

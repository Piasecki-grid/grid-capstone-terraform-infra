resource "azurerm_kubernetes_cluster" "this" {
  name                = "${local.env}-${local.aks_name}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  dns_prefix          = "devaks1"

  automatic_channel_upgrade = "stable"
  private_cluster_enabled   = false
  node_resource_group       = "${local.resource_group_name}-${local.env}-${local.aks_name}"

  # It's in Preview
  # api_server_access_profile {
  #   vnet_integration_enabled = true
  #   subnet_id                = azurerm_subnet.subnet1.id
  # }

  # For production change to "Standard" 
  sku_tier = "Free"

  #oidc_issuer_enabled       = true
  #workload_identity_enabled = true

  network_profile {
    network_plugin = "azure"
    dns_service_ip = "10.0.64.10"
    service_cidr   = "10.0.64.0/19"
  }

  default_node_pool {
    name                = "general"
    vm_size             = "Standard_D2_v2"
    vnet_subnet_id      = azurerm_subnet.subnet1.id
    type                = "VirtualMachineScaleSets"
    enable_auto_scaling = true
    node_count          = 1
    min_count           = 1
    max_count           = 10

    node_labels = {
      role = "general"
    }
  }


  linux_profile {
    admin_username = local.username

    ssh_key {
      key_data = azapi_resource_action.ssh_public_key_gen.output.publicKey
    }
  }

  azure_active_directory_role_based_access_control {
    managed = true
    admin_group_object_ids = [azuread_group.cluster_admins.object_id]
    azure_rbac_enabled     = true
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.base_networking.id]
  }

  tags = {
    env = local.env
  }

  lifecycle {
    ignore_changes = [default_node_pool[0].node_count]
  }

  depends_on = [
    azurerm_role_assignment.networking
  ]
}
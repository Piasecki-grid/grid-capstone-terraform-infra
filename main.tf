resource "azurerm_resource_group" "grid_terraform" {
  name     = "example-resources-afsf"
  location = "West Europe"
}

resource "azurerm_virtual_network" "grid_vnet" {
  name                = "grid-vnet-1242134§"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.grid_terraform.location
  resource_group_name = azurerm_resource_group.grid_terraform.name
}

resource "azurerm_subnet" "subnet_1" {
  name                 = "internal123123"
  resource_group_name  = azurerm_resource_group.grid_terraform.name
  virtual_network_name = azurerm_virtual_network.grid_vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}


resource "azurerm_network_interface" "example" {
  name                = "example-nic-123131"
  location            = azurerm_resource_group.grid_terraform.location
  resource_group_name = azurerm_resource_group.grid_terraform.name

  ip_configuration {
    name                          = "example-nic-123131"
    subnet_id                     = azurerm_subnet.subnet_1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_public_ip.id
  }
}

resource "azurerm_public_ip" "vm_public_ip" {
  name                = "vm-public-ip-12312"
  resource_group_name = azurerm_resource_group.grid_terraform.name
  location            = azurerm_resource_group.grid_terraform.location
  allocation_method   = "Static"
}



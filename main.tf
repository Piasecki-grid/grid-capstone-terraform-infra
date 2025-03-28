resource "azurerm_resource_group" "grid_terraform" {
  name     = "example-resources"
  location = "West Europe"
}

resource "azurerm_virtual_network" "grid_vnet" {
  name                = "grid-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.grid_terraform.location
  resource_group_name = azurerm_resource_group.grid_terraform.name
}

resource "azurerm_subnet" "subnet_1" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.grid_terraform.name
  virtual_network_name = azurerm_virtual_network.grid_vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}


resource "azurerm_network_interface" "example" {
  name                = "example-nic"
  location            = azurerm_resource_group.grid_terraform.location
  resource_group_name = azurerm_resource_group.grid_terraform.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet_1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_public_ip.id
  }
}

resource "azurerm_public_ip" "vm_public_ip" {
  name                = "vm-public-ip"
  resource_group_name = azurerm_resource_group.grid_terraform.name
  location            = azurerm_resource_group.grid_terraform.location
  allocation_method   = "Static"
}



resource "azurerm_linux_virtual_machine" "example" {
  name                = "example-machine"
  resource_group_name = azurerm_resource_group.grid_terraform.name
  location            = azurerm_resource_group.grid_terraform.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/terraform-grid.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
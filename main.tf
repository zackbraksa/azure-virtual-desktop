# Resource Group
resource "azurerm_resource_group" "avd_rg" {
  name     = var.resource_group_name
  location = var.location
}

# Virtual Network
resource "azurerm_virtual_network" "avd_vnet" {
  name                = "avd-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.avd_rg.name
}

# Subnet
resource "azurerm_subnet" "avd_subnet" {
  name                 = "avd-subnet"
  resource_group_name  = azurerm_resource_group.avd_rg.name
  virtual_network_name = azurerm_virtual_network.avd_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Azure Virtual Desktop Host Pool
resource "azurerm_virtual_desktop_host_pool" "avd_hostpool" {
  name                = var.host_pool_name
  location            = var.location
  resource_group_name = azurerm_resource_group.avd_rg.name
  type                = "Pooled"
  load_balancer_type  = "DepthFirst"
}

# Azure Virtual Desktop Application Group (Desktop type)
resource "azurerm_virtual_desktop_application_group" "avd_appgroup" {
  name                = "avd-appgroup"
  location            = var.location
  resource_group_name = azurerm_resource_group.avd_rg.name
  host_pool_id        = azurerm_virtual_desktop_host_pool.avd_hostpool.id
  type                = "Desktop"
}

# Workspace 
resource "azurerm_virtual_desktop_workspace" "avd_workspace" {
  name                = "avd-workspace"
  location            = var.location
  resource_group_name = azurerm_resource_group.avd_rg.name

}

# Windows 11 virtual machine
resource "azurerm_windows_virtual_machine" "win11_vm" {
  name                  = "win11-vm"
  location              = var.location
  resource_group_name   = azurerm_resource_group.avd_rg.name
  network_interface_ids = [azurerm_network_interface.avd_nic.id]
  size                  = "Standard_D2s_v3"

  admin_username = var.admin_username
  admin_password = var.admin_password

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "windows-11"
    sku       = "win11-21h2-avd"
    version   = "latest"
  }

}

# Network Interface
resource "azurerm_network_interface" "avd_nic" {
  name                = "avd-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.avd_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.avd_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.avd_public_ip.id
  }
}

resource "azurerm_public_ip" "avd_public_ip" {
  name                = "avd-public-ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.avd_rg.name
  allocation_method   = "Dynamic"
}


#created infrastructure in a simple way 
resource "azurerm_resource_group" "rg-a" {
  name     = "rg"
  location = "central India"
}
resource "azurerm_virtual_network" "Vnet-a" {
  name                = "Vnet-a"
  location            = azurerm_resource_group.rg-a.location
  resource_group_name = azurerm_resource_group.rg-a.name
  address_space       = ["10.0.0.0/16"]
}
resource "azurerm_subnet" "sub-a" {
  name                 = "subnet-a"
  resource_group_name  = azurerm_resource_group.rg-a.name
  virtual_network_name = azurerm_virtual_network.Vnet-a.name
  address_prefixes     = ["10.0.0.0/24"]
}
resource "azurerm_network_security_group" "nsg-a" {
  name                = "nsg-a"
  location            = azurerm_resource_group.rg-a.location
  resource_group_name = azurerm_resource_group.rg-a.name

  security_rule {

    name                       = "Allow-rdp"
    priority                   = "100"
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {

    name                       = "Allow-Http"
    priority                   = "101"
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
resource "azurerm_public_ip" "pip-a" {
  name                = "pip-a"
  location            = azurerm_resource_group.rg-a.location
  resource_group_name = azurerm_resource_group.rg-a.name
  allocation_method   = "Static"
  sku                 = "Standard"
}
resource "azurerm_network_interface" "nic-a" {
  name                = "nic-a"
  location            = azurerm_resource_group.rg-a.location
  resource_group_name = azurerm_resource_group.rg-a.name

  ip_configuration {

    name                          = "internal"
    subnet_id                     = azurerm_subnet.sub-a.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip-a.id

  }
}
resource "azurerm_network_interface_security_group_association" "assoc-a" {
  network_interface_id      = azurerm_network_interface.nic-a.id
  network_security_group_id = azurerm_network_security_group.nsg-a.id
}
resource "azurerm_windows_virtual_machine" "vma" {

  name                = "vma"
  resource_group_name = azurerm_resource_group.rg-a.name
  location            = azurerm_resource_group.rg-a.location
  size                = "Standard_D2_v3"

  admin_username = var.vm_user
  admin_password = var.vm_pass
  network_interface_ids = [azurerm_network_interface.nic-a.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "Latest"
  }
}
resource "azurerm_resource_group" "rg-b" {
  name     = "rg-b"
  location = "canada central"
}
resource "azurerm_virtual_network" "vnet-b" {
  name                = "vnet-b"
  location            = azurerm_resource_group.rg-b.location
  resource_group_name = azurerm_resource_group.rg-b.name
  address_space       = ["10.1.0.0/16"]
}
resource "azurerm_subnet" "sub-b" {
  name                 = "sub-b"
  resource_group_name  = azurerm_resource_group.rg-b.name
  virtual_network_name = azurerm_virtual_network.vnet-b.name
  address_prefixes     = ["10.1.0.0/24"]
}
resource "azurerm_network_security_group" "nsg-b" {
  name                = "nsg-b"
  location            = azurerm_resource_group.rg-b.location
  resource_group_name = azurerm_resource_group.rg-b.name


  security_rule {
    name                       = "Allow-Rdp"
    priority                   = "100"
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "Allow-Http"
    priority                   = "101"
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
resource "azurerm_public_ip" "pip-b" {
  name                = "pip-b"
  location            = azurerm_resource_group.rg-b.location
  resource_group_name = azurerm_resource_group.rg-b.name
  allocation_method   = "Static"
  sku                 = "Standard"
}
resource "azurerm_network_interface" "nic-b" {
  name           = "nic-b"
  location       = azurerm_resource_group.rg-b.location
  resource_group_name  = azurerm_resource_group.rg-b.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.sub-b.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip-b.id
  }
}
resource "azurerm_network_interface_security_group_association" "assoc-b" {
  network_interface_id      = azurerm_network_interface.nic-b.id
   network_security_group_id = azurerm_network_security_group.nsg-b.id
}
resource "azurerm_windows_virtual_machine" "vm-b" {
  name                = "vmb"
  location            = azurerm_resource_group.rg-b.location
  resource_group_name = azurerm_resource_group.rg-b.name
  size                = "Standard_D2_v3"

  admin_username        = var.usernameb
  admin_password        = var.passb
  network_interface_ids = [azurerm_network_interface.nic-b.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "Latest"
  }
}
resource "azurerm_virtual_network_peering" "a-b" {
       name = "a-b"
       resource_group_name = azurerm_resource_group.rg-a.name
       virtual_network_name = azurerm_virtual_network.Vnet-a.name
       remote_virtual_network_id = azurerm_virtual_network.vnet-b.id

       allow_virtual_network_access  = true
       allow_forwarded_traffic = true

}
resource "azurerm_virtual_network_peering" "b-a"{
          name = "b-a"
          resource_group_name = azurerm_resource_group.rg-b.name
          virtual_network_name = azurerm_virtual_network.vnet-b.name
          remote_virtual_network_id = azurerm_virtual_network.Vnet-a.id
           allow_virtual_network_access = true
          allow_forwarded_traffic    = true
 }


#infra using for_each
resource "azurerm_resource_group" "rg" {
     for_each = var.resource_groups

       name = each.key
       location = each.value
  }
resource "azurerm_virtual_network" "vnet" {
  for_each = var.vnets

  name                = each.key
  location            = azurerm_resource_group.rg[each.value.rg_name].location
  resource_group_name = azurerm_resource_group.rg[each.value.rg_name].name
  address_space       = each.value.address_space
}
resource "azurerm_subnet" "subnet" {
      for_each = var.subnets

      name = each.key
      resource_group_name = azurerm_resource_group.rg[each.value.rg_name].name
      virtual_network_name = each.value.vnet_name
      address_prefixes = each.value.address_prefix
  }
resource "azurerm_public_ip" "pip"{
       for_each = var.pips
        name = each.key
        location = azurerm_resource_group.rg[each.value.rg_name].location
        resource_group_name =azurerm_resource_group.rg[each.value.rg_name].name
        allocation_method= each.value.allocation_method
        sku = each.value.sku
}
resource "azurerm_network_security_group" "nsg"{
          for_each = var.nsgs
           name = each.key
           resource_group_name = azurerm_resource_group.rg[each.value.rg_name].name
           location = azurerm_resource_group.rg[each.value.rg_name].location

          dynamic "security_rule"{
           for_each = each.value.security_rules
         content {
             name = security_rule.value.name
             priority = security_rule.value.priority
             direction = security_rule.value.direction
             access = security_rule.value.access
             protocol = security_rule.value.protocol
             source_port_range = security_rule.value.source_port_range
             destination_port_range = security_rule.value.destination_port_range
             source_address_prefix = security_rule.value.source_address_prefix
             destination_address_prefix = security_rule.value.destination_address_prefix
          }
    }
 }
resource "azurerm_network_interface" "nic" {
        for_each = var.nics

         name = each.key
         location = azurerm_resource_group.rg[each.value.rg_name].location
         resource_group_name = azurerm_resource_group.rg[each.value.rg_name].name
         ip_configuration{
             name = each.value.ip_config.name
             subnet_id = each.value.ip_config.subnet_id
             private_ip_address_allocation = each.value.ip_config.private_ip_address_allocation
             public_ip_address_id = each.value.ip_config.public_ip_address_id
            }
}
resource "azurerm_network_interface_security_group_association" "assoc1" {
         network_interface_id = azurerm_network_interface.nic["nic1"].id
         network_security_group_id = azurerm_network_security_group.nsg["nsg1"].id
    }
resource "azurerm_network_interface_security_group_association" "assoc2" {
         network_interface_id = azurerm_network_interface.nic["nic2"].id
         network_security_group_id = azurerm_network_security_group.nsg["nsg2"].id
}
resource "azurerm_windows_virtual_machine" "vm"{
              for_each = var.vms

              name = each.key
              location = azurerm_resource_group.rg[each.value.rg_name].location
              resource_group_name = azurerm_resource_group.rg[each.value.rg_name].name
 size = "Standard_D2a_v4"
             admin_username = each.value.admin_username
             admin_password = each.value.admin_password

            network_interface_ids = [azurerm_network_interface.nic[each.value.nic_key].id]
            os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_virtual_network_peering" "rg1-rg2" {
             name = "1-2"
             resource_group_name = azurerm_resource_group.rg["rg1"].name
             virtual_network_name = azurerm_virtual_network.vnet["vnet1"].name
             remote_virtual_network_id = azurerm_virtual_network.vnet["vnet2"].id

            allow_virtual_network_access = true
            allow_forwarded_traffic  = true

           }
resource "azurerm_virtual_network_peering" "rg2-rg1" {
             name = "2-1"
             resource_group_name = azurerm_resource_group.rg["rg2"].name
             virtual_network_name = azurerm_virtual_network.vnet["vnet2"].name
             remote_virtual_network_id = azurerm_virtual_network.vnet["vnet1"].id

             allow_virtual_network_access = true
             allow_forwarded_traffic = true
      }

           content {

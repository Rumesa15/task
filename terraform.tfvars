# Values of variables 
resource_groups = {
  rg1 = "Southeast Asia"
  rg2 = "Central India"
}
vnets = {
  vnet1 = {
    address_space = ["10.0.0.0/16"]
    rg_name       = "rg1"
  }

  vnet2 = {
    address_space = ["10.1.0.0/24"]
    rg_name       = "rg2"
  }
}
subnets ={
   sub1 = {
       address_prefix = ["10.0.1.0/24"]
       vnet_name = "vnet1"
       rg_name = "rg1"
    }
   sub2 = {
       address_prefix = ["10.1.0.0/25"]
       vnet_name = "vnet2"
       rg_name = "rg2"
     }
 }
pips = {
    pip1 = {
         rg_name ="rg1"
         allocation_method = "Static"
         sku = "Standard"
     }
   pip2 = {
       rg_name = "rg2"
       allocation_method = "Static"
       sku = "Standard"
    }
  }
nsgs = {
    nsg1= {
        rg_name ="rg1"

       security_rules = {
         rdp ={
            name = "Allow-rdp"
            priority = 100
            direction = "Inbound"
            access = "Allow"
            protocol="Tcp"
            source_port_range ="*"
            destination_port_range ="3389"
            source_address_prefix = "*"
            destination_address_prefix ="*"
         }
          Http = {
              name = "Allow-Http"
              priority = 101
              direction = "Inbound"
              access = "Allow"
              protocol = "Tcp"
              source_port_range = "*"
              destination_port_range = "80"
              source_address_prefix = "*"
              destination_address_prefix = "*"
          }
      }
   }
   nsg2 = {
         rg_name = "rg2"

    security_rules = {
      rdp ={
            name = "Allow-rdp"
            priority = 100
            direction = "Inbound"
            access = "Allow"
            protocol="Tcp"
            source_port_range ="*"
            destination_port_range ="3389"
            source_address_prefix = "*"
            destination_address_prefix ="*"
         }
          Http = {
              name = "Allow-Http"
              priority = 101
              direction = "Inbound"
              access = "Allow"
              protocol = "Tcp"
              source_port_range = "*"
              destination_port_range = "80"
              source_address_prefix = "*"
              destination_address_prefix = "*"
          }
      }
   }
 }
nics = {
       nic1={
              rg_name = "rg1"
         ip_config = {
          name = "internal"
          subnet_id="/subscriptions/7be8f8af-30bc-4988-94c9-d18c2cfcb5f3/resourceGroups/rg1/providers/Microsoft.Network/virtualNetworks/vnet1/subnets/sub1"
          private_ip_address_allocation = "Dynamic"
          public_ip_address_id = "/subscriptions/7be8f8af-30bc-4988-94c9-d18c2cfcb5f3/resourceGroups/rg1/providers/Microsoft.Network/publicIPAddresses/pip1"
      }
   }
       nic2={
                rg_name ="rg2"
       ip_config = {
         name = "internal"
         subnet_id = "/subscriptions/7be8f8af-30bc-4988-94c9-d18c2cfcb5f3/resourceGroups/rg2/providers/Microsoft.Network/virtualNetworks/vnet2/subnets/sub2"
         private_ip_address_allocation = "Dynamic"
         public_ip_address_id = "/subscriptions/7be8f8af-30bc-4988-94c9-d18c2cfcb5f3/resourceGroups/rg2/providers/Microsoft.Network/publicIPAddresses/pip2"
         }
  }
}
vms = {
  vm1 = {
    rg_name ="rg1"
    size = "Standard_DS1_v2"
    admin_username ="Rumesa"
    admin_password ="Password@123"
    nic_key="nic1"
  }

  vm2 = {
    rg_name = "rg2"
    size ="Standard_DS1_v2"
    admin_username ="Rumesa"
    admin_password ="Password@123"
    nic_key = "nic2"
  }
}


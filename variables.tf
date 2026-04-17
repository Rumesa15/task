#defined variables and used map(object) 
variable "resource_groups" {
  description = "Rg names and Locations"
  type        = map(string)
}
variable "vnets" {
  type = map(object({
    address_space = list(string)
    rg_name       = string
  }))
}
variable "subnets" {
    type= map(object({
     address_prefix = list(string)
     vnet_name = string
     rg_name = string
  }))
}
variable "pips"{
    type = map(object({
     rg_name = string
    allocation_method = string
    sku=string
 }))
}
variable "nsgs" {
  type = map(object({
    rg_name = string

    security_rules = map(object({
      name                       = string
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = string
      destination_port_range     = string
      source_address_prefix      = string
      destination_address_prefix = string
    }))
}
variable "nics" {
   type = map(object({
      rg_name = string

      ip_config = object({
         name = string
         subnet_id = string
         private_ip_address_allocation = string
         public_ip_address_id = string
      })
   }))
}
variable "vms" {
       type = map(object({
        rg_name=string
        size = string
        admin_username = string
        admin_password = string
        nic_key = string

  }))
 }
  }))

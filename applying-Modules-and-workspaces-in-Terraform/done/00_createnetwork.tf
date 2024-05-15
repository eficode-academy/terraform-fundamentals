locals {
  yaml_network_data = yamldecode(file("${path.root}/${var.network_configuration}"))
  network           = local.yaml_network_data["data"]
  /*
  Will decode the yaml, creating a data structure we can work with
  */
}

/*
path.root is always the root path of your terraform configuration
If you are developing a module and you want to refer to a path internal to your module, no matter where it is,
you can use path.module
For more information:
  https://developer.hashicorp.com/terraform/language/expressions/references#filesystem-and-workspace-info

*/

resource "azurerm_virtual_network" "main" {
  name                = "vnet-${var.exercise}"
  resource_group_name = data.azurerm_resource_group.studentrg.name
  location            = data.azurerm_resource_group.studentrg.location
  address_space       = local.network.ranges
}

resource "azurerm_subnet" "main" {
  for_each             = local.network.subnets
  name                 = each.key
  resource_group_name  = data.azurerm_resource_group.studentrg.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = each.value.ranges
}
/*
The above is equivalent to:

resource "azurerm_subnet" "client" {
  name                 = "client"
  resource_group_name  = data.azurerm_resource_group.studentrg.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_subnet" "server" {
  name                 = "server"
  resource_group_name  = data.azurerm_resource_group.studentrg.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
}
*/
locals {
  yaml_network_data = yamldecode(file("${path.root}/${var.network_configuration}"))
  network           = local.yaml_network_data["data"]
}

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
resource "azurerm_subnet" "client" {
  name                 = "frontend"
  resource_group_name  = data.azurerm_resource_group.studentrg.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_subnet" "server" {
  name                 = "backend"
  resource_group_name  = data.azurerm_resource_group.studentrg.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
}
*/
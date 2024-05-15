terraform {}

resource "azurerm_virtual_network" "exercise5" {
  name                = "vnet-exercise5"
  resource_group_name = data.azurerm_resource_group.studentrg.name
  location            = data.azurerm_resource_group.studentrg.location
  address_space       = var.network.ranges
}

resource "azurerm_subnet" "client" {
  name                 = var.client_subnet.name
  resource_group_name  = data.azurerm_resource_group.studentrg.name
  virtual_network_name = azurerm_virtual_network.exercise5.name
  address_prefixes     = var.client_subnet.ranges
}

resource "azurerm_subnet" "server" {
  name                 = var.server_subnet.name
  resource_group_name  = data.azurerm_resource_group.studentrg.name
  virtual_network_name = azurerm_virtual_network.exercise5.name
  address_prefixes     = var.server_subnet.ranges
}

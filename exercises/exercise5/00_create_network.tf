terraform {}

resource "azurerm_virtual_network" "exercise5" {
  name                = "vnet-exercise5"
  resource_group_name = data.azurerm_resource_group.studentrg.name
  location            = data.azurerm_resource_group.studentrg.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "client" {
  name                 = "frontend"
  resource_group_name  = data.azurerm_resource_group.studentrg.name
  virtual_network_name = azurerm_virtual_network.exercise5.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_subnet" "server" {
  name                 = "backend"
  resource_group_name  = data.azurerm_resource_group.studentrg.name
  virtual_network_name = azurerm_virtual_network.exercise5.name
  address_prefixes     = ["10.0.1.0/24"]
}

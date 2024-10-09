# provider "azurerm" {
#   features {}
# }

# resource "azurerm_resource_group" "rg" {
#   name     = "terraform-simple-rg"
#   location = "West Europe"
# }

# resource "azurerm_virtual_network" "vnet" {
#   name                = "simple-vnet"
#   address_space       = ["10.0.0.0/16"]
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
# }

# output "resource_group_name" {
#   value = azurerm_resource_group.rg.name
# }

# output "virtual_network_name" {
#   value = azurerm_virtual_network.vnet.name
# }


provider "random" {}

# First random integer resource
resource "random_integer" "example_integer" {
  min = 1
  max = 100
}

# Second random string resource
resource "random_string" "example_string" {
  length  = 16
  special = true
}
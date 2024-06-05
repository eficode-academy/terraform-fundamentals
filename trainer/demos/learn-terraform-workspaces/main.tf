locals {
  resource_group_name = "${terraform.workspace}-rg"
  location            = "West Europe"
}

resource "azurerm_resource_group" "rg" {
  name     = local.resource_group_name
  location = local.location
}

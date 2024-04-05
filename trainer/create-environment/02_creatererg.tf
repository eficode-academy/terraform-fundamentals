resource "azurerm_resource_group" "example" {
  count    = var.number_of_students
  name     = "rg-student${count.index}"
  location = "West Europe"
}

resource "azurerm_role_assignment" "example" {
  count                = var.number_of_students
  scope                = azurerm_resource_group.example[count.index].id
  role_definition_name = "Contributor"
  principal_id         = azuread_user.example[count.index].id
}

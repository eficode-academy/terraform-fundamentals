resource "azurerm_role_assignment" "example" {
  count                = var.number_of_students
  scope                = azurerm_resource_group.example[count.index].id
  role_definition_name = "Contributor"
  principal_id         = azuread_user.example[count.index].id
}

resource "azurerm_role_assignment" "keyvault" {
  count                = var.number_of_students
  scope                = azurerm_resource_group.example[count.index].id
  role_definition_name = "Key Vault Data Access Administrator"
  principal_id         = azuread_user.example[count.index].id
}

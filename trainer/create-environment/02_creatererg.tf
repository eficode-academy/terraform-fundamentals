resource "azurerm_resource_group" "example" {
  count    = var.number_of_students
  # This needs to match the output of modules_intenals\configuration for the exercises to run
  name     = "rg-${local.userid[count.index]}"
  location = "West Europe"
}

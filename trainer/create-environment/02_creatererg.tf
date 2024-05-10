resource "azurerm_resource_group" "example" {
  count    = var.number_of_students
  # This needs to match the output of modules_intenals\configuration for the exercises to run
  name     = "rg-workstation-${count.index + 1}"
  location = "West Europe"
}

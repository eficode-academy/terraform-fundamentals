# Generate a random integer to create a globally unique name
resource "random_integer" "ri" {
  min = 10000
  max = 99999
}

resource "azurerm_service_plan" "example" {
  name                       = "example"
  resource_group_name        = data.azurerm_resource_group.studentrg.name
  location                   = data.azurerm_resource_group.studentrg.location
  os_type                    = "Linux"
  sku_name                   = "B1"
  app_service_environment_id = azurerm_app_service_environment_v3.example.id
}

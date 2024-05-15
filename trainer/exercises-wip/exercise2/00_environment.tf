resource "azurerm_log_analytics_workspace" "example" {
  name                = "acctest-01"
  resource_group_name = data.azurerm_resource_group.studentrg.name
  location            = data.azurerm_resource_group.studentrg.location
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_container_app_environment" "quoteapp" {
  name                       = "Example-Environment"
  resource_group_name        = data.azurerm_resource_group.studentrg.name
  location                   = data.azurerm_resource_group.studentrg.location
  log_analytics_workspace_id = azurerm_log_analytics_workspace.example.id
}
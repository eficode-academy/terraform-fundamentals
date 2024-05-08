resource "azurerm_linux_web_app" "database" {
  name                = "webapp-database-${random_integer.ri.result}"
  location            = data.azurerm_resource_group.studentrg.location
  resource_group_name = data.azurerm_resource_group.studentrg.name
  service_plan_id     = azurerm_service_plan.example.id
  https_only          = true
  site_config {
    minimum_tls_version = "1.2"
    always_on           = false
    application_stack {
      docker_image_name   = "eficode-academy/quotes-flask-frontend:release"
      docker_registry_url = "https://ghcr.io"
    }
  }
}

output "app_url" {
  value = azurerm_linux_web_app.database.default_hostname
}
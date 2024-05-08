resource "azurerm_container_app" "database" {
  name                         = "database"
  container_app_environment_id = azurerm_container_app_environment.quoteapp.id
  resource_group_name          = data.azurerm_resource_group.studentrg.name
  revision_mode                = "Single"

  template {
    min_replicas = 1
    max_replicas = 1
    container {
      name   = "quotes-flask-database"
      image  = "docker.io/library/postgres:14.3"
      cpu    = 0.25
      memory = "0.5Gi"
      env {
        name  = "POSTGRES_USER"
        value = "superuser"
      }
      env {
        name  = "POSTGRES_DB"
        value = "quotes"
      }
      env {
        name  = "POSTGRES_PASSWORD"
        value = "Y29tcGxpY2F0ZWQ="
      }
    }
  }
  ingress {
    external_enabled = false
    target_port      = 5432
    exposed_port     = 5432
    transport        = "tcp"
    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }
}

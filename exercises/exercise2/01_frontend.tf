

resource "azurerm_container_app" "frontend" {
  name                         = "frontend"
  container_app_environment_id = azurerm_container_app_environment.quoteapp.id
  resource_group_name          = data.azurerm_resource_group.studentrg.name
  revision_mode                = "Single"

  template {
    min_replicas = 1
    container {
      name   = "quotes-flask-frontend"
      image  = "ghcr.io/eficode-academy/quotes-flask-frontend:release"
      cpu    = 0.25
      memory = "0.5Gi"
      env {
        name  = "BACKEND_HOST"
        value = "backend"
        #value = azurerm_container_app.backend.ingress[0].fqdn
      }
      env {
        name  = "BACKEND_PORT"
        value = 80
      }
    }
  }
  ingress {
    external_enabled = true
    target_port      = 5000
    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }
}

resource "azurerm_container_app" "backend" {
  name                         = "backend"
  container_app_environment_id = azurerm_container_app_environment.quoteapp.id
  resource_group_name          = data.azurerm_resource_group.studentrg.name
  revision_mode                = "Single"

  template {
    min_replicas = 1
    max_replicas = 1
    container {
      name   = "backend"
      image  = "ghcr.io/eficode-academy/quotes-flask-backend:release"
      cpu    = 0.25
      memory = "0.5Gi"
      env {
        name  = "DB_HOST"
        value = "database"
        #value = azurerm_container_app.database.ingress[0].fqdn
        #value = "${azurerm_container_app.database.ingress[0].fqdn}"      
      }
      env {
        name  = "DB_PORT"
        value = "5432"
      }
      env {
        name  = "DB_USER"
        value = "superuser"
      }
      env {
        name  = "DB_NAME"
        value = "quotes"
      }
      env {
        name  = "DB_PASSWORD"
        value = "Y29tcGxpY2F0ZWQ="
      }
    }
  }

  ingress {
    external_enabled           = false
    target_port                = 5000
    allow_insecure_connections = true
    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }
}

data "azurerm_container_app" "frontend" {
  name                = azurerm_container_app.frontend.name
  resource_group_name = azurerm_container_app.frontend.resource_group_name
}

data "azurerm_container_app" "backend" {
  name                = azurerm_container_app.backend.name
  resource_group_name = azurerm_container_app.backend.resource_group_name
}
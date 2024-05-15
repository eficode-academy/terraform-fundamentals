/*
resource "azurerm_user_assigned_identity" "quotesapp" {
  name                = "id-quoteapp"
  location            = data.azurerm_resource_group.studentrg.location
  resource_group_name = data.azurerm_resource_group.studentrg.name
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "quotesapp" {
  name                       = "kv-quotesapp"
  location                   = data.azurerm_resource_group.studentrg.location
  resource_group_name        = data.azurerm_resource_group.studentrg.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7
  purge_protection_enabled   = true
}

resource "azurerm_key_vault_access_policy" "server" {
  key_vault_id = azurerm_key_vault.quotesapp.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_user_assigned_identity.quotesapp.principal_id

  key_permissions    = ["Get", "UnwrapKey", "WrapKey"]
  secret_permissions = ["Get"]
}

resource "azurerm_key_vault_access_policy" "client" {
  key_vault_id = azurerm_key_vault.quotesapp.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  key_permissions    = ["Get", "Create", "Delete", "List", "Restore", "Recover", "UnwrapKey", "WrapKey", "Purge", "Encrypt", "Decrypt", "Sign", "Verify", "GetRotationPolicy"]
  secret_permissions = ["Get"]
}

resource "azurerm_key_vault_access_policy" "student" {
  key_vault_id = azurerm_key_vault.quotesapp.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  key_permissions    = ["Get", "Create", "Delete", "List", "Restore", "Recover", "UnwrapKey", "WrapKey", "Purge", "Encrypt", "Decrypt", "Sign", "Verify", "GetRotationPolicy"]
  secret_permissions = ["Get"]
}

resource "azurerm_key_vault_key" "quotesapp" {
  name         = "exampleKVkey"
  key_vault_id = azurerm_key_vault.quotesapp.id
  key_type     = "RSA"
  key_size     = 2048
  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey"
  ]

  depends_on = [
    azurerm_key_vault_access_policy.client,
    azurerm_key_vault_access_policy.server,
  ]
}

resource "azurerm_app_configuration" "quotesapp" {
  name                       = "appConf37583573"
  location                   = data.azurerm_resource_group.studentrg.location
  resource_group_name        = data.azurerm_resource_group.studentrg.name
  sku                        = "standard"
  local_auth_enabled         = true
  public_network_access      = "Enabled"
  purge_protection_enabled   = false
  soft_delete_retention_days = 1

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.quotesapp.id,
    ]
  }

  encryption {
    key_vault_key_identifier = azurerm_key_vault_key.quotesapp.id
    identity_client_id       = azurerm_user_assigned_identity.quotesapp.client_id
  }

  replica {
    name     = "replica1"
    location = "North Europe"
  }

  depends_on = [
    azurerm_key_vault_access_policy.client,
    azurerm_key_vault_access_policy.server,
  ]

}
*/
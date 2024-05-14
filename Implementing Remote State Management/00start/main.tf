data "azurerm_client_config" "current" {}


# Generate random value for the storage account name
resource "random_string" "storage_account_name_tfstate" {
  length  = 8
  lower   = true
  numeric = false
  special = false
  upper   = false
}

resource "azurerm_storage_account" "storage_account_tfstate" {
  resource_group_name = data.azurerm_resource_group.studentrg.name
  location            = data.azurerm_resource_group.studentrg.location

  name = random_string.storage_account_name_tfstate.result

  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  allow_nested_items_to_be_public  = false

  static_website {
    index_document = "index.html"
  }
}


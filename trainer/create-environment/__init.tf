terraform {
  required_version = "~> 1.6.1"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.98.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.47.0"
    }
  }

  backend "azurerm" {
    tenant_id            = "ce98c903-f521-4028-89dc-13227927e323"
    subscription_id      = "769d8f7e-e398-4cbf-8014-0019e1fdee59"
    resource_group_name  = "rg-terraform"
    storage_account_name = "stacademytfprod"
    container_name       = "tf-training-env-state"
    key                  = "create-users.tfstate"
    use_azuread_auth     = true
   }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy          = false
      purge_soft_deleted_secrets_on_destroy = false
      purge_soft_deleted_keys_on_destroy    = false
    }
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  tenant_id       = "ce98c903-f521-4028-89dc-13227927e323"
  subscription_id = "769d8f7e-e398-4cbf-8014-0019e1fdee59"
}

provider "azuread" {
  tenant_id = "ce98c903-f521-4028-89dc-13227927e323"
}
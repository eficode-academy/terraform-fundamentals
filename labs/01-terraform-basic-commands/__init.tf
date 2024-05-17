terraform {
  required_version = "> 1.6.1"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.98.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4.0"
    }
    random = {
      source = "hashicorp/random"
    }
  }
  backend "local" {}
}


provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy          = false
      purge_soft_deleted_secrets_on_destroy = false
      purge_soft_deleted_keys_on_destroy    = false
    }
  }
  tenant_id       = "ce98c903-f521-4028-89dc-13227927e323"
  subscription_id = "769d8f7e-e398-4cbf-8014-0019e1fdee59"
}

variable "SHORT_HOSTNAME" {
  type     = string
  nullable = true
}

#Get the resource group where to deploy
module "exerciseconfiguration" {
  source = "../../modules_internals/configuration"
  #If SHORT_HOSTNAME is not set (or env TF_VAR_SHORT_HOSTNAME) use the module default
  workstationname = try(var.SHORT_HOSTNAME, false)
}

# Make the resource group data available in terraform
data "azurerm_resource_group" "studentrg" {
  name = module.exerciseconfiguration.rgname
}
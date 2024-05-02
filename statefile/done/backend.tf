terraform {
  backend "azurerm" {
    resource_group_name   = "rg-testexercise"
    storage_account_name  = "efitfstate"
    container_name        = "tfstate"
    key                   = "training.terraform.tfstate"
    tenant_id             = "ce98c903-f521-4028-89dc-13227927e323"
    subscription_id       = "769d8f7e-e398-4cbf-8014-0019e1fdee59"
  }
}
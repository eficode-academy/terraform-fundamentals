module "exerciseconfiguration" {
  source = "../../modules_internals/configuration"
}

data "azurerm_resource_group" "studentrg" {
  name     = module.exerciseconfiguration.rgname
}
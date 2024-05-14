variable "SHORT_HOSTNAME" {
  type     = string
  nullable = true
}

#Get the resource group where to deploy
module "exerciseconfiguration" {
  source = "../modules_internals/configuration"
  #If SHORT_HOSTNAME is not set (or env TF_VAR_SHORT_HOSTNAME) use the module default
  workstationname = try(var.SHORT_HOSTNAME, false)
}

# Make the resource group data available in terraform
data "azurerm_resource_group" "studentrg" {
  name = module.exerciseconfiguration.rgname
}
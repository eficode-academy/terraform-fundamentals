
output "storage_account_name" {
  value = azurerm_storage_account.storage_account_tfstate.name
}

output "container_name"{
  value = azurerm_storage_container.tfstate_container.name
}

output "resource_group_name"{
  value = data.azurerm_resource_group.studentrg.name
}
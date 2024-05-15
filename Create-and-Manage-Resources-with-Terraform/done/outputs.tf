
output "storage_account_name" {
  value = azurerm_storage_account.storage_account.name
}

output "primary_web_host" {
  value = azurerm_storage_account.storage_account.primary_web_host
}
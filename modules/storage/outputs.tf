output "storage_account_id" {
  description = "ID du compte de stockage"
  value       = azurerm_storage_account.main.id
}

output "storage_account_name" {
  description = "Nom du compte de stockage"
  value       = azurerm_storage_account.main.name
}

output "primary_blob_endpoint" {
  description = "Endpoint blob principal"
  value       = azurerm_storage_account.main.primary_blob_endpoint
}

output "primary_access_key" {
  description = "Clé d'accès principale du compte de stockage"
  value       = azurerm_storage_account.main.primary_access_key
  sensitive   = true
}

output "container_name" {
  description = "Nom du conteneur blob"
  value       = azurerm_storage_container.main.name
}

output "container_id" {
  description = "ID du conteneur blob"
  value       = azurerm_storage_container.main.id
}

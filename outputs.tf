# Outputs Resource Group
output "resource_group_name" {
  description = "Nom du resource group principal"
  value       = data.azurerm_resource_group.main.name
}

output "resource_group_location" {
  description = "Localisation du resource group"
  value       = data.azurerm_resource_group.main.location
}

# Outputs VM
output "vm_public_ip" {
  description = "Adresse IP publique de la VM"
  value       = module.virtual_machine.public_ip_address
}

output "vm_name" {
  description = "Nom de la VM"
  value       = module.virtual_machine.vm_name
}

output "vm_admin_username" {
  description = "Nom d'utilisateur administrateur de la VM"
  value       = var.vm_admin_username
}

# Outputs Storage
output "storage_account_name" {
  description = "Nom du compte de stockage"
  value       = module.storage.storage_account_name
}

output "storage_account_primary_blob_endpoint" {
  description = "Endpoint blob principal du compte de stockage"
  value       = module.storage.primary_blob_endpoint
}

output "blob_container_name" {
  description = "Nom du conteneur blob"
  value       = module.storage.container_name
}

# Outputs Web App
output "webapp_url" {
  description = "URL de la Web App"
  value       = module.webapp.webapp_url
}

output "webapp_name" {
  description = "Nom de la Web App"
  value       = module.webapp.webapp_name
}

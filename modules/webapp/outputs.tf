output "app_service_plan_id" {
  description = "ID du plan App Service"
  value       = azurerm_service_plan.main.id
}

output "webapp_id" {
  description = "ID de la Web App"
  value       = azurerm_linux_web_app.main.id
}

output "webapp_name" {
  description = "Nom de la Web App"
  value       = azurerm_linux_web_app.main.name
}

output "webapp_url" {
  description = "URL de la Web App"
  value       = "https://${azurerm_linux_web_app.main.default_hostname}"
}

output "webapp_default_hostname" {
  description = "Nom d'hôte par défaut de la Web App"
  value       = azurerm_linux_web_app.main.default_hostname
}

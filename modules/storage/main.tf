# Génération d'un nom unique pour le storage account
# Les noms de storage account doivent être uniques globalement et en minuscules
resource "random_string" "storage_suffix" {
  length  = 6
  special = false
  upper   = false
}

# Storage Account
resource "azurerm_storage_account" "main" {
  name                     = "${var.project_name}${var.environment}sa${random_string.storage_suffix.result}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  tags                     = var.tags

  # Configuration de sécurité minimale
  min_tls_version                 = "TLS1_2"
  https_traffic_only_enabled      = true
  allow_nested_items_to_be_public = false
}

# Blob Container
resource "azurerm_storage_container" "main" {
  name                  = var.blob_container_name
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}

# Resource Group principal
resource "azurerm_resource_group" "main" {
  name     = "${var.project_name}-${var.environment}-rg"
  location = var.location
  tags     = var.tags
}

# Module VM
module "virtual_machine" {
  source = "./modules/vm"

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  project_name        = var.project_name
  environment         = var.environment
  vm_size             = var.vm_size
  admin_username      = var.vm_admin_username
  admin_password      = var.vm_admin_password
  tags                = var.tags
}

# Module Storage Account
module "storage" {
  source = "./modules/storage"

  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  project_name             = var.project_name
  environment              = var.environment
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_account_replication_type
  blob_container_name      = var.blob_container_name
  tags                     = var.tags
}

# Module Web App
module "webapp" {
  source = "./modules/webapp"

  resource_group_name  = azurerm_resource_group.main.name
  location             = azurerm_resource_group.main.location
  project_name         = var.project_name
  environment          = var.environment
  app_service_plan_sku = var.app_service_plan_sku
  tags                 = var.tags
}

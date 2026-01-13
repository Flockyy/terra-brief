# App Service Plan
resource "azurerm_service_plan" "main" {
  name                = "${var.project_name}-${var.environment}-asp"
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = "Linux"
  sku_name            = var.app_service_plan_sku
  tags                = var.tags
}

# Web App (Linux App Service)
resource "azurerm_linux_web_app" "main" {
  name                = "${var.project_name}-${var.environment}-webapp-${random_string.webapp_suffix.result}"
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.main.id
  tags                = var.tags

  site_config {
    always_on = false # False pour le tier gratuit F1

    # Configuration d'une application Node.js de base
    application_stack {
      node_version = "18-lts"
    }
  }

  # Configuration basique
  app_settings = {
    "WEBSITE_NODE_DEFAULT_VERSION" = "~18"
  }
}

# Génération d'un nom unique pour la web app
resource "random_string" "webapp_suffix" {
  length  = 6
  special = false
  upper   = false
}

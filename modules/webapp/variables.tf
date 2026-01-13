variable "resource_group_name" {
  description = "Nom du resource group"
  type        = string
}

variable "location" {
  description = "Localisation Azure"
  type        = string
}

variable "project_name" {
  description = "Nom du projet"
  type        = string
}

variable "environment" {
  description = "Environnement"
  type        = string
}

variable "app_service_plan_sku" {
  description = "SKU du plan App Service"
  type        = string
}

variable "tags" {
  description = "Tags à appliquer"
  type        = map(string)
}

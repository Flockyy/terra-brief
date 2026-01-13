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

variable "account_tier" {
  description = "Niveau de performance du compte de stockage"
  type        = string
}

variable "account_replication_type" {
  description = "Type de réplication"
  type        = string
}

variable "blob_container_name" {
  description = "Nom du conteneur blob"
  type        = string
}

variable "tags" {
  description = "Tags à appliquer"
  type        = map(string)
}

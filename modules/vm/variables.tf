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

variable "vm_size" {
  description = "Taille de la VM"
  type        = string
}

variable "admin_username" {
  description = "Nom d'utilisateur administrateur"
  type        = string
}

variable "admin_password" {
  description = "Mot de passe administrateur"
  type        = string
  sensitive   = true
}

variable "tags" {
  description = "Tags à appliquer"
  type        = map(string)
}

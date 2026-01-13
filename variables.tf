# Variables globales
variable "project_name" {
  description = "Nom du projet utilisé comme préfixe pour toutes les ressources"
  type        = string
  default     = "datacorp"
}

variable "environment" {
  description = "Environnement de déploiement (dev, test, prod)"
  type        = string
  default     = "dev"
}

variable "location" {
  description = "Région Azure pour le déploiement des ressources"
  type        = string
  default     = "France Central"
}

variable "tags" {
  description = "Tags communs à appliquer à toutes les ressources"
  type        = map(string)
  default = {
    Project     = "DataCorp Training"
    ManagedBy   = "Terraform"
    Environment = "dev"
  }
}

# Variables VM
variable "vm_size" {
  description = "Taille de la machine virtuelle"
  type        = string
  default     = "Standard_B1s" # 1 vCPU, 1 GB RAM - économique
}

variable "vm_admin_username" {
  description = "Nom d'utilisateur administrateur de la VM"
  type        = string
  default     = "azureuser"
}

variable "vm_admin_password" {
  description = "Mot de passe administrateur de la VM (utiliser une variable d'environnement ou Azure Key Vault en production)"
  type        = string
  sensitive   = true
  default     = "P@ssw0rd1234!" # À changer en production !
}

# Variables Storage
variable "storage_account_tier" {
  description = "Niveau de performance du compte de stockage"
  type        = string
  default     = "Standard"
}

variable "storage_account_replication_type" {
  description = "Type de réplication du compte de stockage"
  type        = string
  default     = "LRS" # Locally Redundant Storage - économique
}

variable "blob_container_name" {
  description = "Nom du conteneur blob"
  type        = string
  default     = "data-container"
}

# Variables Web App
variable "app_service_plan_sku" {
  description = "SKU du plan App Service"
  type        = string
  default     = "F1" # Free tier - économique
}

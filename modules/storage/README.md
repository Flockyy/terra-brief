# Module Storage

Ce module déploie un Azure Storage Account avec un Blob Container pour le stockage de données.

## Ressources créées

- **Random String** : Génération d'un suffixe unique (6 caractères)
- **Storage Account** : Compte de stockage Azure (Standard LRS)
- **Blob Container** : Conteneur pour stocker des objets (fichiers)

## Variables

| Nom | Type | Description | Défaut |
|-----|------|-------------|--------|
| `resource_group_name` | string | Nom du resource group | - |
| `location` | string | Région Azure | - |
| `project_name` | string | Nom du projet (préfixe) | - |
| `environment` | string | Environnement (dev/test/prod) | - |
| `account_tier` | string | Tier du Storage Account | - |
| `account_replication_type` | string | Type de réplication (LRS/GRS/ZRS) | - |
| `blob_container_name` | string | Nom du conteneur blob | - |
| `tags` | map(string) | Tags à appliquer | - |

## Outputs

| Nom | Description |
|-----|-------------|
| `storage_account_id` | ID du compte de stockage |
| `storage_account_name` | Nom du compte de stockage |
| `primary_blob_endpoint` | Endpoint blob principal |
| `primary_access_key` | Clé d'accès (sensible) |
| `container_name` | Nom du conteneur blob |
| `container_id` | ID du conteneur |

## Exemple d'utilisation

```hcl
module "storage" {
  source = "./modules/storage"

  resource_group_name       = azurerm_resource_group.main.name
  location                  = azurerm_resource_group.main.location
  project_name              = "datacorp"
  environment               = "dev"
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  blob_container_name       = "data-container"
  tags                      = var.tags
}
```

## Types de réplication

- **LRS** : Locally Redundant Storage (3 copies locales) - Économique
- **GRS** : Geo-Redundant Storage (réplication géographique) - Plus cher
- **ZRS** : Zone-Redundant Storage (réplication entre zones)

## Upload de fichiers

### Via Azure CLI

```bash
# Upload d'un fichier
az storage blob upload \
  --account-name <STORAGE_NAME> \
  --container-name data-container \
  --name myfile.csv \
  --file ./myfile.csv

# Lister les blobs
az storage blob list \
  --account-name <STORAGE_NAME> \
  --container-name data-container \
  --output table
```

### Via Azure Storage Explorer

Utiliser [Azure Storage Explorer](https://azure.microsoft.com/features/storage-explorer/) pour une interface graphique.

## Cas d'usage Data Engineering

- **Data Lake** : Stockage de données brutes (CSV, JSON, Parquet)
- **ETL** : Source et destination pour transformations
- **Backup** : Sauvegarde de modèles ML
- **Archive** : Données historiques
- **Staging** : Zone de transit pour pipelines

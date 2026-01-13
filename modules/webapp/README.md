# Module Web App

Ce module déploie une Azure Web App (App Service) sur Linux pour héberger des applications web ou des APIs.

## Ressources créées

- **Random String** : Génération d'un suffixe unique (6 caractères)
- **App Service Plan** : Plan d'hébergement (Linux, F1 tier)
- **Linux Web App** : Application web avec runtime Node.js

## Variables

| Nom | Type | Description | Défaut |
|-----|------|-------------|--------|
| `resource_group_name` | string | Nom du resource group | - |
| `location` | string | Région Azure | - |
| `project_name` | string | Nom du projet (préfixe) | - |
| `environment` | string | Environnement (dev/test/prod) | - |
| `app_service_plan_sku` | string | SKU du plan (F1/B1/S1/P1) | - |
| `tags` | map(string) | Tags à appliquer | - |

## Outputs

| Nom | Description |
|-----|-------------|
| `app_service_plan_id` | ID du plan App Service |
| `webapp_id` | ID de la Web App |
| `webapp_name` | Nom de la Web App |
| `webapp_url` | URL complète de la Web App |
| `webapp_default_hostname` | Hostname par défaut |

## Exemple d'utilisation

```hcl
module "webapp" {
  source = "./modules/webapp"

  resource_group_name   = azurerm_resource_group.main.name
  location              = azurerm_resource_group.main.location
  project_name          = "datacorp"
  environment           = "dev"
  app_service_plan_sku  = "F1"
  tags                  = var.tags
}
```

## SKUs disponibles

| SKU | Nom | CPU | RAM | Prix/mois | Always On |
|-----|-----|-----|-----|-----------|-----------|
| F1 | Free | Partagé | 1 Go | Gratuit | Non |
| B1 | Basic | 1 vCPU | 1.75 Go | ~10€ | Oui |
| S1 | Standard | 1 vCPU | 1.75 Go | ~60€ | Oui |
| P1V2 | Premium | 1 vCPU | 3.5 Go | ~120€ | Oui |

## Runtimes supportés

Le module est configuré par défaut avec Node.js 18, mais supporte :

- Node.js (10, 12, 14, 16, 18)
- Python (3.7, 3.8, 3.9, 3.10, 3.11)
- Java (8, 11, 17)
- .NET Core (3.1, 6.0, 7.0)
- PHP (7.4, 8.0, 8.1)
- Ruby (2.7, 3.0)

## Déploiement d'une application

### Via Azure CLI

```bash
# Déployer depuis un repo Git
az webapp deployment source config \
  --name <WEBAPP_NAME> \
  --resource-group datacorp-dev-rg \
  --repo-url https://github.com/user/repo \
  --branch main

# Déployer un ZIP
az webapp deployment source config-zip \
  --name <WEBAPP_NAME> \
  --resource-group datacorp-dev-rg \
  --src ./app.zip
```

### Via VS Code

Installer l'extension [Azure App Service](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-azureappservice).

### Via GitHub Actions

Configurer un workflow CI/CD pour déployer automatiquement.

## Accès à la Web App

```bash
# Ouvrir dans le navigateur
WEBAPP_URL=$(terraform output -raw webapp_url)
open $WEBAPP_URL  # macOS
# ou
xdg-open $WEBAPP_URL  # Linux

# Tester avec curl
curl -I $WEBAPP_URL
```

## Logs et monitoring

```bash
# Activer les logs
az webapp log config \
  --name <WEBAPP_NAME> \
  --resource-group datacorp-dev-rg \
  --application-logging filesystem \
  --level information

# Stream des logs en temps réel
az webapp log tail \
  --name <WEBAPP_NAME> \
  --resource-group datacorp-dev-rg
```

## Cas d'usage Data Engineering

- **API REST** : Exposer des données transformées via endpoints
- **Dashboard** : Visualisation de métriques et KPIs
- **Webhook** : Recevoir des événements pour déclencher des pipelines
- **Jupyter Hub** : Notebooks collaboratifs pour l'équipe data
- **MLflow** : Tracking et versioning de modèles ML
- **Streamlit** : Applications data science interactives
- **FastAPI** : APIs performantes pour servir des modèles ML

## Configuration avancée

### Variables d'environnement

Ajouter dans le bloc `app_settings` de `main.tf` :

```hcl
app_settings = {
  "DATABASE_URL"    = "postgresql://..."
  "API_KEY"         = var.api_key
  "ENVIRONMENT"     = var.environment
}
```

### Connexion à une base de données

```hcl
app_settings = {
  "AZURE_STORAGE_CONNECTION_STRING" = module.storage.connection_string
  "DATABASE_URL"                    = "..."
}
```

### Custom domain

```bash
az webapp config hostname add \
  --webapp-name <WEBAPP_NAME> \
  --resource-group datacorp-dev-rg \
  --hostname www.example.com
```

## Limitations du tier gratuit (F1)

⚠️ **Contraintes :**
- 60 minutes CPU/jour
- 1 Go de stockage
- Pas de custom domain SSL
- Always On désactivé (cold start)
- Pas de slots de déploiement
- Pas d'auto-scaling

💡 **Pour la production**, utiliser au minimum le tier B1 (Basic).

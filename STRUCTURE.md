# Structure du Projet Terraform

```
terra-brief/
│
├── 📄 Configuration Terraform principale
│   ├── provider.tf                  # Configuration des providers (azurerm, random)
│   ├── main.tf                      # Point d'entrée principal, appelle les modules
│   ├── variables.tf                 # Variables globales du projet
│   ├── outputs.tf                   # Outputs globaux du projet
│   └── terraform.tfvars.example     # Exemple de fichier de variables (à copier)
│
├── 📁 modules/                      # Modules Terraform réutilisables
│   │
│   ├── 🖥️ vm/                       # Module Machine Virtuelle
│   │   ├── main.tf                 # VM + VNet + Subnet + NSG + IP publique + NIC
│   │   ├── variables.tf            # Variables du module VM
│   │   └── outputs.tf              # Outputs du module VM (IP publique, nom, etc.)
│   │
│   ├── 💾 storage/                  # Module Storage Account
│   │   ├── main.tf                 # Storage Account + Blob Container
│   │   ├── variables.tf            # Variables du module Storage
│   │   └── outputs.tf              # Outputs du module Storage (nom, endpoint, etc.)
│   │
│   └── 🌐 webapp/                   # Module Web App
│       ├── main.tf                 # App Service Plan + Linux Web App
│       ├── variables.tf            # Variables du module Web App
│       └── outputs.tf              # Outputs du module Web App (URL, nom, etc.)
│
├── 📚 Documentation
│   ├── README.md                    # Documentation principale du projet
│   ├── DOCUMENTATION_TECHNIQUE.md   # Explication détaillée des étapes
│   ├── COMMANDES.md                 # Aide-mémoire des commandes Terraform
│   ├── LIVRAISON.md                 # Guide de préparation du livrable
│   └── STRUCTURE.md                 # Ce fichier
│
├── 🛠️ Outils
│   └── prepare-livraison.sh         # Script de nettoyage et création du ZIP
│
└── 📋 Autres
    └── .gitignore                   # Fichiers à ignorer par Git
```

---

## 📊 Statistiques du projet

- **Total de fichiers Terraform** : 13 fichiers `.tf`
- **Total de modules** : 3 modules (VM, Storage, Web App)
- **Total de ressources Azure** : ~10 ressources principales
- **Lignes de code** : ~500 lignes (commentaires inclus)
- **Documentation** : 5 fichiers Markdown

---

## 🔍 Description des fichiers

### Fichiers principaux

| Fichier | Rôle | Contenu |
|---------|------|---------|
| `provider.tf` | Configuration provider | Définit les providers nécessaires (azurerm, random) |
| `main.tf` | Point d'entrée | Resource Group + Appels aux modules |
| `variables.tf` | Variables globales | Toutes les variables configurables du projet |
| `outputs.tf` | Outputs globaux | Informations importantes (IP, URLs, noms) |
| `terraform.tfvars.example` | Exemple de config | Template pour le fichier de variables personnalisées |

### Module VM (`modules/vm/`)

**Ressources déployées :**
- `azurerm_virtual_network` : Réseau virtuel
- `azurerm_subnet` : Sous-réseau
- `azurerm_public_ip` : IP publique
- `azurerm_network_security_group` : Pare-feu réseau
- `azurerm_network_interface` : Interface réseau
- `azurerm_network_interface_security_group_association` : Association NSG-NIC
- `azurerm_linux_virtual_machine` : VM Linux Ubuntu 22.04

**Total : 7 ressources**

### Module Storage (`modules/storage/`)

**Ressources déployées :**
- `random_string` : Génération d'un suffixe unique
- `azurerm_storage_account` : Compte de stockage
- `azurerm_storage_container` : Conteneur blob

**Total : 3 ressources**

### Module Web App (`modules/webapp/`)

**Ressources déployées :**
- `random_string` : Génération d'un suffixe unique
- `azurerm_service_plan` : Plan App Service
- `azurerm_linux_web_app` : Web App Linux

**Total : 3 ressources**

---

## 🎯 Flux de données

```
terraform.tfvars (vos valeurs)
        ↓
variables.tf (définitions)
        ↓
main.tf (orchestration)
        ↓
    ┌───┴────┬──────────┐
    ↓        ↓          ↓
modules/vm  storage  webapp
    ↓        ↓          ↓
Azure Cloud (ressources déployées)
    ↓        ↓          ↓
outputs.tf (résultats)
```

---

## 📦 Contenu de chaque module

### Module VM - Détails

```hcl
modules/vm/
├── main.tf (130 lignes)
│   ├── Virtual Network      (10.0.0.0/16)
│   ├── Subnet              (10.0.1.0/24)
│   ├── Public IP           (Static)
│   ├── NSG                 (SSH rule port 22)
│   ├── Network Interface   (Dynamic private IP)
│   ├── NSG Association     
│   └── Linux VM            (Ubuntu 22.04, Standard_B1s)
│
├── variables.tf (8 variables)
│   ├── resource_group_name
│   ├── location
│   ├── project_name
│   ├── environment
│   ├── vm_size
│   ├── admin_username
│   ├── admin_password
│   └── tags
│
└── outputs.tf (5 outputs)
    ├── vm_id
    ├── vm_name
    ├── public_ip_address
    ├── private_ip_address
    └── network_interface_id
```

### Module Storage - Détails

```hcl
modules/storage/
├── main.tf (30 lignes)
│   ├── Random String       (6 caractères)
│   ├── Storage Account     (Standard LRS)
│   └── Blob Container      (Private access)
│
├── variables.tf (8 variables)
│   ├── resource_group_name
│   ├── location
│   ├── project_name
│   ├── environment
│   ├── account_tier
│   ├── account_replication_type
│   ├── blob_container_name
│   └── tags
│
└── outputs.tf (6 outputs)
    ├── storage_account_id
    ├── storage_account_name
    ├── primary_blob_endpoint
    ├── primary_access_key
    ├── container_name
    └── container_id
```

### Module Web App - Détails

```hcl
modules/webapp/
├── main.tf (40 lignes)
│   ├── Random String       (6 caractères)
│   ├── App Service Plan    (Linux, F1 tier)
│   └── Linux Web App       (Node.js 18)
│
├── variables.tf (6 variables)
│   ├── resource_group_name
│   ├── location
│   ├── project_name
│   ├── environment
│   ├── app_service_plan_sku
│   └── tags
│
└── outputs.tf (5 outputs)
    ├── app_service_plan_id
    ├── webapp_id
    ├── webapp_name
    ├── webapp_url
    └── webapp_default_hostname
```

---

## 🔄 Cycle de vie Terraform

```
1. terraform init
   ↓
   Télécharge les providers (azurerm, random)
   Initialise le backend (local par défaut)
   
2. terraform validate
   ↓
   Vérifie la syntaxe HCL
   Valide les références entre ressources
   
3. terraform plan
   ↓
   Compare l'état actuel avec la configuration
   Affiche les changements prévus
   Calcule le graphe de dépendances
   
4. terraform apply
   ↓
   Crée/Modifie/Supprime les ressources
   Respecte l'ordre des dépendances
   Met à jour le fichier d'état (.tfstate)
   Affiche les outputs
   
5. terraform destroy
   ↓
   Supprime toutes les ressources
   Dans l'ordre inverse de création
   Nettoie le fichier d'état
```

---

## 🏗️ Ordre de création des ressources

```
1. Resource Group (datacorp-dev-rg)
   │
   ├─→ 2. Virtual Network (datacorp-dev-vnet)
   │   └─→ 3. Subnet (datacorp-dev-subnet)
   │       └─→ 5. Network Interface
   │           └─→ 7. VM (datacorp-dev-vm)
   │
   ├─→ 4. Public IP (datacorp-dev-pip) ──┘
   │
   ├─→ 6. NSG (datacorp-dev-nsg) ─→ NSG Association
   │
   ├─→ 8. Storage Account (datacorpdevsaXXXXXX)
   │   └─→ 9. Blob Container (data-container)
   │
   └─→ 10. App Service Plan (datacorp-dev-asp)
       └─→ 11. Web App (datacorp-dev-webapp-XXXXXX)
```

**Temps de déploiement estimé : 5-10 minutes**

---

## 📝 Variables disponibles

### Variables globales (variables.tf)

| Variable | Type | Défaut | Description |
|----------|------|--------|-------------|
| `project_name` | string | "datacorp" | Préfixe pour toutes les ressources |
| `environment` | string | "dev" | Environnement (dev/test/prod) |
| `location` | string | "France Central" | Région Azure |
| `tags` | map | {...} | Tags communs |
| `vm_size` | string | "Standard_B1s" | Taille de la VM |
| `vm_admin_username` | string | "azureuser" | Username admin VM |
| `vm_admin_password` | string | - | Mot de passe VM (sensible) |
| `storage_account_tier` | string | "Standard" | Tier du Storage Account |
| `storage_account_replication_type` | string | "LRS" | Type de réplication |
| `blob_container_name` | string | "data-container" | Nom du container blob |
| `app_service_plan_sku` | string | "F1" | SKU du plan App Service |

---

## 📤 Outputs disponibles

| Output | Description | Exemple |
|--------|-------------|---------|
| `resource_group_name` | Nom du Resource Group | datacorp-dev-rg |
| `vm_public_ip` | IP publique de la VM | 20.74.123.45 |
| `vm_name` | Nom de la VM | datacorp-dev-vm |
| `storage_account_name` | Nom du Storage Account | datacorpdevsa8h3k2f |
| `storage_account_primary_blob_endpoint` | Endpoint blob | https://...blob.core.windows.net/ |
| `blob_container_name` | Nom du container | data-container |
| `webapp_url` | URL de la Web App | https://datacorp-dev-webapp-ab12cd.azurewebsites.net |
| `webapp_name` | Nom de la Web App | datacorp-dev-webapp-ab12cd |

---

## 🎓 Concepts Terraform appliqués

✅ **Modularité** : Code réparti en modules réutilisables  
✅ **Variables** : Configuration flexible via variables  
✅ **Outputs** : Récupération d'informations importantes  
✅ **Dependencies** : Gestion automatique de l'ordre  
✅ **Providers** : Utilisation de multiple providers (azurerm, random)  
✅ **Best Practices** : Naming conventions, tags, sécurité  
✅ **DRY** : Don't Repeat Yourself (modules évitent la duplication)

---

## 🔐 Fichiers à ne PAS commiter

Fichiers exclus par `.gitignore` :

```
.terraform/              # Dossier des plugins
*.tfstate                # Fichier d'état (contient toutes les infos)
*.tfstate.*              # Backups d'état
*.tfvars                 # Variables personnelles (mots de passe)
.terraform.lock.hcl      # Lock file des providers (optionnel)
```

---

## ✅ Checklist de qualité

- [x] Code modulaire et réutilisable
- [x] Variables paramétrées
- [x] Outputs bien définis
- [x] Naming conventions cohérentes
- [x] Tags appliqués partout
- [x] Documentation complète
- [x] .gitignore configuré
- [x] Ressources économiques (coûts minimaux)
- [x] Sécurité de base (NSG, HTTPS, private containers)
- [x] Scripts d'aide fournis

---

## 📊 Métriques du projet

- **Modules Terraform** : 3
- **Ressources Azure** : ~10
- **Fichiers de documentation** : 5
- **Variables configurables** : 11
- **Outputs disponibles** : 10
- **Coût mensuel estimé** : 10-15€

---

**Date de création** : 13 janvier 2026  
**Version Terraform** : >= 1.0  
**Provider AzureRM** : ~> 3.0

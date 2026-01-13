# Documentation Technique - Explication des Étapes

## 🏗️ Création des Ressources Azure

Cette documentation détaille les étapes de création de chaque ressource et explique les choix techniques.

---

## 1️⃣ Resource Group (Groupe de Ressources)

### Fichier : `main.tf`

```hcl
resource "azurerm_resource_group" "main" {
  name     = "${var.project_name}-${var.environment}-rg"
  location = var.location
  tags     = var.tags
}
```

### Explication

Le **Resource Group** est le conteneur logique qui regroupe toutes les ressources Azure du projet. C'est la première ressource à créer car toutes les autres ressources y seront rattachées.

**Pourquoi c'est important en Data Engineering ?**
- Permet d'organiser toutes les ressources d'un projet au même endroit
- Facilite la gestion des coûts (facturation par Resource Group)
- Permet de supprimer toutes les ressources en une seule opération

### Ordre de création
1. Resource Group (première ressource créée)

---

## 2️⃣ Machine Virtuelle (VM) Linux

### Module : `modules/vm/`

### Étape 1 : Réseau virtuel (Virtual Network)

```hcl
resource "azurerm_virtual_network" "main" {
  name                = "${var.project_name}-${var.environment}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}
```

**Explication :** Le Virtual Network (VNet) est le réseau privé virtuel dans Azure. Il isole la VM du reste d'Internet et permet une communication sécurisée.

**Plage d'adresses :** `10.0.0.0/16` donne 65,536 adresses IP disponibles.

### Étape 2 : Sous-réseau (Subnet)

```hcl
resource "azurerm_subnet" "main" {
  name                 = "${var.project_name}-${var.environment}-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
}
```

**Explication :** Le Subnet est une subdivision du VNet. C'est là que la VM sera connectée.

**Plage d'adresses :** `10.0.1.0/24` donne 256 adresses IP.

### Étape 3 : IP publique

```hcl
resource "azurerm_public_ip" "main" {
  name                = "${var.project_name}-${var.environment}-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}
```

**Explication :** L'IP publique permet d'accéder à la VM depuis Internet (via SSH).

**Static vs Dynamic :** Static garantit que l'IP ne changera jamais, même si la VM est arrêtée.

### Étape 4 : Network Security Group (NSG)

```hcl
resource "azurerm_network_security_group" "main" {
  name                = "${var.project_name}-${var.environment}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
```

**Explication :** Le NSG agit comme un firewall. Il définit les règles de trafic réseau autorisé.

**Règle SSH :** Autorise les connexions sur le port 22 (SSH) pour se connecter à la VM.

⚠️ **Note sécurité :** En production, il faudrait restreindre `source_address_prefix` à votre IP spécifique.

### Étape 5 : Interface réseau (NIC)

```hcl
resource "azurerm_network_interface" "main" {
  name                = "${var.project_name}-${var.environment}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main.id
  }
}
```

**Explication :** La NIC est la "carte réseau virtuelle" de la VM. Elle la connecte au subnet et à l'IP publique.

### Étape 6 : Association NSG ↔ NIC

```hcl
resource "azurerm_network_interface_security_group_association" "main" {
  network_interface_id      = azurerm_network_interface.main.id
  network_security_group_id = azurerm_network_security_group.main.id
}
```

**Explication :** Lie les règles de sécurité du NSG à l'interface réseau.

### Étape 7 : Machine virtuelle

```hcl
resource "azurerm_linux_virtual_machine" "main" {
  name                = "${var.project_name}-${var.environment}-vm"
  location            = var.location
  resource_group_name = var.resource_group_name
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  tags                = var.tags

  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.main.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 30
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}
```

**Explication :**

- **size** : `Standard_B1s` = 1 vCPU, 1 Go RAM (économique)
- **os_disk** : Disque de 30 Go en Standard LRS (local)
- **image** : Ubuntu Server 22.04 LTS (dernière version stable)

### Ordre de création (VM)
1. Virtual Network
2. Subnet (dépend du VNet)
3. Public IP
4. Network Security Group
5. Network Interface (dépend du Subnet et Public IP)
6. NSG ↔ NIC Association
7. VM (dépend de la NIC)

**Cas d'usage Data Engineering :**
- Exécuter des jobs Spark
- Héberger Airflow pour l'orchestration
- Environnement de développement isolé
- Testing de pipelines ETL

---

## 3️⃣ Storage Account et Blob Container

### Module : `modules/storage/`

### Étape 1 : Génération d'un suffixe unique

```hcl
resource "random_string" "storage_suffix" {
  length  = 6
  special = false
  upper   = false
}
```

**Explication :** Les noms de Storage Account doivent être **globalement uniques** sur Azure (pas seulement dans votre subscription). Le suffixe aléatoire garantit l'unicité.

### Étape 2 : Storage Account

```hcl
resource "azurerm_storage_account" "main" {
  name                     = "${var.project_name}${var.environment}sa${random_string.storage_suffix.result}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  tags                     = var.tags

  min_tls_version                 = "TLS1_2"
  enable_https_traffic_only       = true
  allow_nested_items_to_be_public = false
}
```

**Explication :**

- **account_tier** : `Standard` (performance normale, économique)
- **account_replication_type** : `LRS` (Locally Redundant Storage - 3 copies locales)
- **Sécurité** : 
  - TLS 1.2 minimum
  - HTTPS obligatoire
  - Pas d'accès public par défaut

**Types de réplication disponibles :**
- **LRS** : 3 copies locales (économique)
- **GRS** : Réplication géographique (plus cher)
- **ZRS** : Réplication entre zones de disponibilité

### Étape 3 : Blob Container

```hcl
resource "azurerm_storage_container" "main" {
  name                  = var.blob_container_name
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}
```

**Explication :** Le Blob Container est comme un "dossier" dans le Storage Account. C'est là qu'on stockera les fichiers (CSV, JSON, Parquet, etc.).

**Access types :**
- **private** : Accès authentifié uniquement (recommandé)
- **blob** : Accès public en lecture aux blobs
- **container** : Accès public en lecture au container et aux blobs

### Ordre de création (Storage)
1. Random String (pour le nom unique)
2. Storage Account (dépend du random string)
3. Blob Container (dépend du Storage Account)

**Cas d'usage Data Engineering :**
- **Data Lake** : Stockage de données brutes
- **ETL** : Source et destination de transformations
- **Backup** : Sauvegarde de modèles ML
- **Archive** : Données historiques
- **Staging** : Zone de transit pour les pipelines

---

## 4️⃣ Web App (App Service)

### Module : `modules/webapp/`

### Étape 1 : Génération d'un suffixe unique

```hcl
resource "random_string" "webapp_suffix" {
  length  = 6
  special = false
  upper   = false
}
```

**Explication :** Même raison que pour le Storage Account - les noms de Web App doivent être uniques (domaine `*.azurewebsites.net`).

### Étape 2 : App Service Plan

```hcl
resource "azurerm_service_plan" "main" {
  name                = "${var.project_name}-${var.environment}-asp"
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = "Linux"
  sku_name            = var.app_service_plan_sku
  tags                = var.tags
}
```

**Explication :** L'App Service Plan définit les ressources (CPU, RAM, prix) allouées à la Web App.

**SKUs disponibles :**
- **F1** : Gratuit (60 min CPU/jour, 1 Go stockage)
- **B1** : Basic (~10€/mois)
- **S1** : Standard (~60€/mois)
- **P1V2** : Premium (~120€/mois)

### Étape 3 : Web App (Linux)

```hcl
resource "azurerm_linux_web_app" "main" {
  name                = "${var.project_name}-${var.environment}-webapp-${random_string.webapp_suffix.result}"
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.main.id
  tags                = var.tags

  site_config {
    always_on = false
    
    application_stack {
      node_version = "18-lts"
    }
  }

  app_settings = {
    "WEBSITE_NODE_DEFAULT_VERSION" = "~18"
  }
}
```

**Explication :**

- **always_on** : `false` pour le tier gratuit (obligation)
- **application_stack** : Définit le runtime (ici Node.js 18)

**Runtimes supportés :**
- Node.js
- Python
- Java
- .NET Core
- PHP
- Ruby

### Ordre de création (Web App)
1. Random String
2. App Service Plan
3. Linux Web App (dépend de l'App Service Plan)

**Cas d'usage Data Engineering :**
- **API REST** : Exposer des données transformées
- **Dashboard** : Visualisation de métriques
- **Webhook** : Déclenchement de pipelines
- **Jupyter Hub** : Notebooks collaboratifs
- **MLflow** : Tracking de modèles ML

---

## 📊 Dépendances entre ressources

```
Resource Group
    │
    ├─→ Virtual Network
    │       └─→ Subnet
    │               └─→ Network Interface ←─┐
    │                       └─→ VM          │
    │                                       │
    ├─→ Public IP ─────────────────────────┘
    │
    ├─→ Network Security Group ─→ NSG Association
    │
    ├─→ Storage Account
    │       └─→ Blob Container
    │
    └─→ App Service Plan
            └─→ Web App
```

### Terraform gère automatiquement l'ordre de création grâce au graphe de dépendances !

---

## 🔍 Vérification des ressources déployées

### 1. Via le portail Azure

**Étapes :**
1. Ouvrir [portal.azure.com](https://portal.azure.com)
2. Rechercher le Resource Group : `datacorp-dev-rg`
3. Vérifier la présence de :
   - ✅ 1 Machine virtuelle
   - ✅ 1 Réseau virtuel
   - ✅ 1 Sous-réseau
   - ✅ 1 IP publique
   - ✅ 1 Interface réseau
   - ✅ 1 NSG
   - ✅ 1 Compte de stockage
   - ✅ 1 Container blob
   - ✅ 1 App Service Plan
   - ✅ 1 Web App

**Total : 10 ressources principales**

### 2. Via Azure CLI

#### Lister toutes les ressources du Resource Group

```bash
az resource list --resource-group datacorp-dev-rg --output table
```

#### Vérifier la VM

```bash
# Statut de la VM
az vm show \
  --resource-group datacorp-dev-rg \
  --name datacorp-dev-vm \
  --query "provisioningState" \
  --output tsv

# Résultat attendu : Succeeded
```

#### Vérifier le Storage Account

```bash
# Récupérer le nom du Storage Account
STORAGE_NAME=$(terraform output -raw storage_account_name)

# Vérifier l'existence
az storage account show \
  --name $STORAGE_NAME \
  --query "provisioningState" \
  --output tsv

# Lister les containers
az storage container list \
  --account-name $STORAGE_NAME \
  --output table
```

#### Vérifier la Web App

```bash
# Récupérer le nom de la Web App
WEBAPP_NAME=$(terraform output -raw webapp_name)

# Vérifier le statut
az webapp show \
  --resource-group datacorp-dev-rg \
  --name $WEBAPP_NAME \
  --query "state" \
  --output tsv

# Résultat attendu : Running
```

### 3. Tester la connectivité

#### Se connecter à la VM via SSH

```bash
VM_IP=$(terraform output -raw vm_public_ip)
ssh azureuser@$VM_IP
```

#### Tester la Web App

```bash
WEBAPP_URL=$(terraform output -raw webapp_url)
curl -I $WEBAPP_URL
```

**Résultat attendu :** Code HTTP 200 ou 503 (service démarré mais pas d'application déployée)

---

## 💰 Estimation des coûts

| Ressource | Configuration | Coût mensuel (estimation) |
|-----------|--------------|--------------------------|
| VM Standard_B1s | 1 vCPU, 1 Go RAM | ~7€ |
| Storage Account LRS | Premier Go gratuit | ~0.02€/Go |
| Public IP Standard | Statique | ~3€ |
| Bande passante | Sortie Internet | Variable |
| Web App F1 | Tier gratuit | 0€ |
| **TOTAL** | | **~10-15€/mois** |

**⚠️ Important :** 
- Arrêter la VM quand elle n'est pas utilisée pour économiser
- Supprimer l'infrastructure avec `terraform destroy` après les tests

---

## 🎯 Résumé des étapes

1. **Initialisation** : `terraform init`
2. **Planification** : `terraform plan`
3. **Déploiement** : `terraform apply`
4. **Vérification** : Portail Azure + CLI
5. **Destruction** : `terraform destroy`

---

## 📚 Concepts Terraform utilisés

- **Resources** : Déclaration de ressources Azure
- **Modules** : Organisation et réutilisation du code
- **Variables** : Paramétrage flexible
- **Outputs** : Récupération de valeurs
- **Dependencies** : Gestion automatique de l'ordre
- **Providers** : Interaction avec Azure (azurerm)
- **Random** : Génération de valeurs aléatoires

---

**Date de création** : 13 janvier 2026

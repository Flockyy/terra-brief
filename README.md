# Projet Terraform
# Infrastructure Azure pour Data Engineering

## 📋 Contexte

Ce projet déploie une infrastructure Azure basique pour des cas d'usage Data Engineering, comprenant :
- **Machine Virtuelle Linux** : Pour l'exécution de jobs de transformation de données
- **Storage Account avec Blob Container** : Pour le stockage de données brutes et transformées
- **Web App** : Pour exposer des API ou des dashboards

## 📁 Structure du projet

```
terra-brief/
├── provider.tf                 # Configuration du provider Azure
├── main.tf                     # Configuration principale appelant les modules
├── variables.tf                # Variables globales du projet
├── outputs.tf                  # Outputs du projet
├── terraform.tfvars.example    # Exemple de fichier de variables
├── .gitignore                  # Fichiers à ignorer par Git
├── README.md                   # Ce fichier
└── modules/
    ├── vm/                     # Module Machine Virtuelle
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── storage/                # Module Storage Account
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    └── webapp/                 # Module Web App
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

## 🚀 Prérequis

1. **Terraform** installé (version >= 1.0)
   ```bash
   terraform --version
   ```

2. **Azure CLI** installé et configuré
   ```bash
   az --version
   az login
   ```

3. **Subscription Azure** active avec les permissions nécessaires

## ⚙️ Configuration

### 1. Créer le fichier de variables

Copier le fichier d'exemple et le personnaliser :

```bash
cp terraform.tfvars.example terraform.tfvars
```

Éditer `terraform.tfvars` avec vos valeurs :

```hcl
project_name = "datacorp"
environment  = "dev"
location     = "France Central"

vm_admin_username = "azureuser"
# Définir le mot de passe via variable d'environnement
```

### 2. Définir le mot de passe administrateur (recommandé)

Pour des raisons de sécurité, définissez le mot de passe via une variable d'environnement :

```bash
export TF_VAR_vm_admin_password="VotreMotDePasseSecurise!"
```

Ou ajoutez-le dans `terraform.tfvars` (⚠️ ne pas commiter ce fichier) :

```hcl
vm_admin_password = "VotreMotDePasseSecurise!"
```

## 📦 Déploiement

### Étape 1 : Initialiser Terraform

```bash
terraform init
```

Cette commande télécharge les providers nécessaires (azurerm) et initialise le backend.

### Étape 2 : Planifier le déploiement

```bash
terraform plan
```

Cette commande affiche un aperçu des ressources qui seront créées sans les déployer réellement.

### Étape 3 : Déployer l'infrastructure

```bash
terraform apply
```

Terraform vous demandera confirmation. Tapez `yes` pour procéder au déploiement.

⏱️ Le déploiement prend environ **5-10 minutes**.

### Étape 4 : Récupérer les outputs

Une fois le déploiement terminé, Terraform affiche les informations importantes :

```bash
terraform output
```

Pour récupérer une valeur spécifique :

```bash
terraform output vm_public_ip
terraform output webapp_url
```

## ✅ Vérification du déploiement

### Via le portail Azure

1. Connectez-vous au [Portail Azure](https://portal.azure.com)
2. Recherchez votre Resource Group : `datacorp-dev-rg`
3. Vérifiez la présence des ressources :
   - Machine virtuelle : `datacorp-dev-vm`
   - Compte de stockage : `datacorpdevsa******`
   - Web App : `datacorp-dev-webapp-******`

### Via Azure CLI

#### Vérifier le Resource Group

```bash
az group show --name datacorp-dev-rg
```

#### Vérifier la VM

```bash
az vm show --resource-group datacorp-dev-rg --name datacorp-dev-vm
az vm get-instance-view --resource-group datacorp-dev-rg --name datacorp-dev-vm
```

#### Vérifier le Storage Account

```bash
# Lister les comptes de stockage
az storage account list --resource-group datacorp-dev-rg --output table

# Récupérer le nom du compte
STORAGE_NAME=$(terraform output -raw storage_account_name)

# Lister les conteneurs
az storage container list --account-name $STORAGE_NAME --output table
```

#### Vérifier la Web App

```bash
az webapp show --resource-group datacorp-dev-rg --name $(terraform output -raw webapp_name)
```

#### Tester la Web App

```bash
curl $(terraform output -raw webapp_url)
```

### Se connecter à la VM

```bash
VM_IP=$(terraform output -raw vm_public_ip)
ssh azureuser@$VM_IP
```

## 📊 Ressources déployées

| Ressource | Type | Description | Coût estimé |
|-----------|------|-------------|-------------|
| VM Linux | Standard_B1s | 1 vCPU, 1 Go RAM, Ubuntu 22.04 | ~7€/mois |
| Storage Account | Standard LRS | Stockage localement redondant | ~0.02€/Go |
| Blob Container | - | Conteneur pour les données | Inclus |
| Web App | F1 (Free) | Plan gratuit Linux | Gratuit |
| Network (VNet, Subnet, NSG, IP) | - | Infrastructure réseau | ~3€/mois |
| **TOTAL** | - | - | **~10-15€/mois** |

## 🧹 Suppression de l'infrastructure

Pour supprimer toutes les ressources déployées :

```bash
terraform destroy
```

Tapez `yes` pour confirmer la suppression.

⚠️ **Attention** : Cette action est irréversible !

## 🔧 Personnalisation

### Changer la taille de la VM

Dans `terraform.tfvars` :

```hcl
vm_size = "Standard_B2s"  # 2 vCPU, 4 Go RAM
```

### Changer la région Azure

```hcl
location = "West Europe"
```

### Changer le tier de la Web App

```hcl
app_service_plan_sku = "B1"  # Basic, ~10€/mois
```

## 📝 Notes importantes

### Sécurité

- ⚠️ **Ne jamais commiter** de mots de passe ou clés d'accès dans Git
- Utilisez Azure Key Vault pour stocker les secrets en production
- Le NSG autorise SSH depuis n'importe quelle IP (à restreindre en production)

### Bonnes pratiques appliquées

✅ Code modulaire et réutilisable  
✅ Variables paramétrées  
✅ Outputs pour récupérer les informations importantes  
✅ Ressources avec naming convention cohérent  
✅ Tags appliqués pour traçabilité  
✅ Configuration minimale pour réduire les coûts

### Limitations

- **Tier gratuit F1** de la Web App : 
  - 60 minutes CPU/jour
  - 1 Go de stockage
  - Pas de custom domain SSL
  - Toujours en mode "always on" désactivé

- **VM Standard_B1s** : 
  - Performance limitée
  - Non recommandée pour production

## 🎓 Concepts Terraform utilisés

- **Providers** : Configuration Azure
- **Resources** : Déclaration des ressources Azure
- **Modules** : Organisation du code
- **Variables** : Paramétrage
- **Outputs** : Récupération des valeurs
- **Dependencies** : Gestion automatique par Terraform

## 🆘 Troubleshooting

### Erreur d'authentification Azure

```bash
az login
az account set --subscription "votre-subscription-id"
```

### Erreur de nom de Storage Account déjà pris

Le Storage Account génère un suffixe aléatoire, mais si l'erreur persiste, changez `project_name` dans `terraform.tfvars`.

### Erreur de quota dépassé

Vérifiez vos quotas Azure :

```bash
az vm list-usage --location "France Central" --output table
```

## 📚 Ressources

- [Documentation Terraform](https://www.terraform.io/docs)
- [Provider AzureRM](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Azure CLI Documentation](https://docs.microsoft.com/cli/azure/)
- [Azure Pricing Calculator](https://azure.microsoft.com/pricing/calculator/)

---

**Date limite de rendu** : 13/01/2026 à 17h00

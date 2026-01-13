# 🚀 Quick Start - Démarrage Rapide

Guide de démarrage en 5 minutes pour déployer l'infrastructure Azure.

## ⚡ Démarrage ultra-rapide

```bash
# 1. Se connecter à Azure
az login

# 2. Configurer les variables
cp terraform.tfvars.example terraform.tfvars
export TF_VAR_vm_admin_password="VotreMotDePasseSecurise!"

# 3. Déployer
terraform init
terraform apply -auto-approve

# 4. Voir les résultats
terraform output
```

---

## 📋 Prérequis

- ✅ [Terraform](https://www.terraform.io/downloads) >= 1.0
- ✅ [Azure CLI](https://docs.microsoft.com/cli/azure/install-azure-cli)
- ✅ Compte Azure avec crédit disponible

---

## 🔧 Installation des outils

### macOS (Homebrew)

```bash
brew install terraform azure-cli
```

### Windows (Chocolatey)

```bash
choco install terraform azure-cli
```

### Linux (Ubuntu/Debian)

```bash
# Terraform
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform

# Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
```

---

## 🎯 Déploiement étape par étape

### 1. Configuration Azure

```bash
# Connexion
az login

# Vérifier la subscription
az account show

# (Optionnel) Changer de subscription
az account list --output table
az account set --subscription "SUBSCRIPTION_ID"
```

### 2. Configuration du projet

```bash
# Cloner ou extraire le projet
cd terra-brief/

# Copier le fichier de variables
cp terraform.tfvars.example terraform.tfvars

# Éditer avec vos valeurs (optionnel)
# vim terraform.tfvars
```

### 3. Définir le mot de passe VM

**Option 1 : Variable d'environnement (recommandé)**

```bash
export TF_VAR_vm_admin_password="P@ssw0rd1234!"
```

**Option 2 : Dans terraform.tfvars**

```hcl
vm_admin_password = "P@ssw0rd1234!"
```

### 4. Initialisation Terraform

```bash
terraform init
```

**Résultat attendu :**
```
Initializing modules...
Initializing the backend...
Initializing provider plugins...
- Finding hashicorp/azurerm versions matching "~> 3.0"...
- Finding hashicorp/random versions matching "~> 3.0"...
- Installing hashicorp/azurerm v3.x.x...
- Installing hashicorp/random v3.x.x...

Terraform has been successfully initialized!
```

### 5. Validation (optionnel)

```bash
terraform validate
terraform fmt -check -recursive
```

### 6. Plan

```bash
terraform plan
```

**Résultat attendu :**
```
Plan: 13 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + resource_group_name = "datacorp-dev-rg"
  + vm_public_ip        = (known after apply)
  + ...
```

### 7. Déploiement

```bash
terraform apply
```

Ou sans confirmation :

```bash
terraform apply -auto-approve
```

**Durée : 5-10 minutes**

### 8. Récupérer les informations

```bash
# Tous les outputs
terraform output

# Output spécifique
terraform output vm_public_ip
terraform output webapp_url
```

---

## ✅ Vérification rapide

### Via Azure CLI

```bash
# Vérifier le Resource Group
az group show --name datacorp-dev-rg

# Lister toutes les ressources
az resource list --resource-group datacorp-dev-rg --output table

# Tester la Web App
curl -I $(terraform output -raw webapp_url)
```

### Via le portail Azure

1. Ouvrir [portal.azure.com](https://portal.azure.com)
2. Rechercher "datacorp-dev-rg"
3. Vérifier les ~10 ressources

### Connexion SSH à la VM

```bash
VM_IP=$(terraform output -raw vm_public_ip)
ssh azureuser@$VM_IP
```

---

## 🧹 Nettoyage

```bash
# Détruire toutes les ressources
terraform destroy

# Ou sans confirmation
terraform destroy -auto-approve
```

---

## 🆘 Dépannage rapide

### Erreur d'authentification

```bash
az logout
az login
az account set --subscription "YOUR_SUBSCRIPTION_ID"
```

### Nom de Storage Account déjà pris

Changer `project_name` dans `terraform.tfvars` :

```hcl
project_name = "datacorp2"
```

### Quota dépassé

```bash
az vm list-usage --location "France Central" --output table
```

---

## 📚 Documentation complète

Pour plus de détails, voir :

- [README.md](README.md) - Documentation principale
- [DOCUMENTATION_TECHNIQUE.md](DOCUMENTATION_TECHNIQUE.md) - Détails techniques
- [COMMANDES.md](COMMANDES.md) - Toutes les commandes
- [VALIDATION.md](VALIDATION.md) - Checklist de validation

---

## 💡 Astuces

### Alias pratiques

```bash
alias tf='terraform'
alias tfi='terraform init'
alias tfp='terraform plan'
alias tfa='terraform apply'
alias tfd='terraform destroy'
```

### Raccourci déploiement

```bash
# Tout en une commande
terraform init && terraform apply -auto-approve && terraform output
```

### Logs détaillés

```bash
export TF_LOG=DEBUG
terraform apply
```

---

## 📊 Ce qui sera créé

| Ressource | Configuration | Coût/mois |
|-----------|--------------|-----------|
| VM Linux | Standard_B1s (1 vCPU, 1 Go) | ~7€ |
| Storage | Standard LRS | ~0.02€/Go |
| Web App | F1 (Free) | 0€ |
| Network | VNet, IP, NSG | ~3€ |
| **TOTAL** | | **~10-15€** |

---

## ⏱️ Timeline

```
0:00 - az login                    [30s]
0:30 - Configuration                [1min]
1:30 - terraform init               [30s]
2:00 - terraform plan               [20s]
2:20 - terraform apply              [5-7min]
9:00 - Vérification                 [2min]
```

**Total : ~10 minutes** ⚡

---

## 🎯 Commandes les plus utilisées

```bash
# Initialiser
terraform init

# Voir les changements
terraform plan

# Déployer
terraform apply

# Voir les infos
terraform output

# Détruire
terraform destroy
```

---

**🚀 Prêt à déployer ? Commencez par `terraform init` !**

# Commandes Terraform - Aide-mémoire

## 🚀 Déploiement complet

```bash
# 1. Se connecter à Azure
az login

# 2. Vérifier la subscription active
az account show

# 3. (Optionnel) Changer de subscription
az account set --subscription "SUBSCRIPTION_ID"

# 4. Copier le fichier de variables
cp terraform.tfvars.example terraform.tfvars

# 5. Éditer terraform.tfvars avec vos valeurs
# vim terraform.tfvars

# 6. Définir le mot de passe VM (variable d'environnement)
export TF_VAR_vm_admin_password="VotreMotDePasseSecurise!"

# 7. Initialiser Terraform
terraform init

# 8. Formater le code (optionnel)
terraform fmt -recursive

# 9. Valider la configuration
terraform validate

# 10. Voir le plan d'exécution
terraform plan

# 11. Déployer l'infrastructure
terraform apply

# 12. Afficher les outputs
terraform output
```

---

## 📋 Commandes de base

### Initialisation

```bash
# Initialiser le projet (télécharge les providers)
terraform init

# Réinitialiser (en cas de problème)
terraform init -upgrade
```

### Planification

```bash
# Voir les changements prévus
terraform plan

# Sauvegarder le plan dans un fichier
terraform plan -out=tfplan

# Appliquer un plan sauvegardé
terraform apply tfplan
```

### Déploiement

```bash
# Déployer (avec confirmation)
terraform apply

# Déployer sans confirmation (automatique)
terraform apply -auto-approve

# Déployer seulement certaines ressources
terraform apply -target=module.virtual_machine
```

### Destruction

```bash
# Détruire toute l'infrastructure (avec confirmation)
terraform destroy

# Détruire sans confirmation
terraform destroy -auto-approve

# Détruire seulement certaines ressources
terraform destroy -target=module.webapp
```

---

## 🔍 Commandes d'inspection

### État (State)

```bash
# Lister toutes les ressources
terraform state list

# Afficher les détails d'une ressource
terraform state show azurerm_resource_group.main

# Afficher tout l'état
terraform show

# Afficher l'état en JSON
terraform show -json
```

### Outputs

```bash
# Afficher tous les outputs
terraform output

# Afficher un output spécifique
terraform output vm_public_ip

# Afficher la valeur brute (sans guillemets)
terraform output -raw webapp_url

# Afficher en JSON
terraform output -json
```

### Validation

```bash
# Valider la configuration
terraform validate

# Formater le code
terraform fmt

# Formater récursivement
terraform fmt -recursive

# Vérifier le formatage (sans modifier)
terraform fmt -check
```

---

## 🛠️ Commandes utiles

### Graph

```bash
# Générer le graphe de dépendances (format DOT)
terraform graph

# Visualiser avec Graphviz (si installé)
terraform graph | dot -Tpng > graph.png
```

### Console

```bash
# Ouvrir une console interactive Terraform
terraform console

# Dans la console, on peut évaluer des expressions :
# > var.project_name
# > module.virtual_machine.vm_name
```

### Import

```bash
# Importer une ressource existante dans Terraform
terraform import azurerm_resource_group.main /subscriptions/SUBSCRIPTION_ID/resourceGroups/datacorp-dev-rg
```

### Workspace (gestion de plusieurs environnements)

```bash
# Lister les workspaces
terraform workspace list

# Créer un nouveau workspace
terraform workspace new prod

# Changer de workspace
terraform workspace select dev

# Supprimer un workspace
terraform workspace delete staging
```

---

## 🔧 Commandes de dépannage

### Logs de débogage

```bash
# Activer les logs détaillés
export TF_LOG=DEBUG
terraform apply

# Logs dans un fichier
export TF_LOG_PATH=./terraform.log
terraform apply

# Désactiver les logs
unset TF_LOG
unset TF_LOG_PATH
```

### Problèmes de state

```bash
# Rafraîchir l'état sans modifier l'infrastructure
terraform refresh

# Supprimer une ressource de l'état (sans la détruire)
terraform state rm module.webapp.azurerm_linux_web_app.main

# Déplacer une ressource dans l'état
terraform state mv azurerm_resource_group.old azurerm_resource_group.new
```

### Lock state

```bash
# Forcer le déverrouillage (si bloqué)
terraform force-unlock LOCK_ID
```

---

## 📦 Commandes de préparation du livrable

### Nettoyage

```bash
# Supprimer les fichiers temporaires
rm -rf .terraform
rm -f *.tfstate *.tfstate.* .terraform.lock.hcl
rm -f terraform.tfvars

# Utiliser le script fourni
./prepare-livraison.sh
```

### Création du ZIP

```bash
# Depuis le dossier parent
cd ..
zip -r datacorp-terraform-projet.zip terra-brief/ \
  -x "*.terraform/*" \
  -x "*terraform.tfstate*" \
  -x "*.tfvars" \
  -x "*/.DS_Store" \
  -x "*/.git/*"
```

---

## 🔐 Variables d'environnement

```bash
# Définir des variables Terraform via l'environnement
export TF_VAR_project_name="datacorp"
export TF_VAR_environment="prod"
export TF_VAR_location="West Europe"
export TF_VAR_vm_admin_password="SecureP@ssw0rd!"

# Afficher les variables d'environnement Terraform
env | grep TF_VAR
```

---

## 🧪 Commandes de test

### Validation complète

```bash
# Valider + Formater + Planifier
terraform fmt -recursive && \
terraform validate && \
terraform plan
```

### Test rapide

```bash
# Plan sans demander de confirmation
terraform plan -input=false
```

---

## 📊 Commandes Azure CLI (complémentaires)

### Resource Group

```bash
# Lister tous les Resource Groups
az group list --output table

# Afficher les détails
az group show --name datacorp-dev-rg

# Supprimer un Resource Group (alternative à terraform destroy)
az group delete --name datacorp-dev-rg --yes
```

### Ressources

```bash
# Lister toutes les ressources d'un RG
az resource list --resource-group datacorp-dev-rg --output table

# Compter les ressources
az resource list --resource-group datacorp-dev-rg --query "length(@)"
```

### Coûts

```bash
# Afficher les coûts du Resource Group
az consumption usage list --output table
```

---

## 💡 Astuces

### Raccourcis

```bash
# Alias utiles à ajouter dans ~/.zshrc ou ~/.bashrc
alias tf='terraform'
alias tfi='terraform init'
alias tfp='terraform plan'
alias tfa='terraform apply'
alias tfd='terraform destroy'
alias tfo='terraform output'
alias tfv='terraform validate'
alias tff='terraform fmt -recursive'
```

### Auto-complétion

```bash
# Activer l'auto-complétion Terraform (bash)
terraform -install-autocomplete

# Relancer le shell
exec $SHELL
```

---

## 📖 Ordre recommandé des commandes

### Première fois (déploiement)

```bash
1. az login
2. cp terraform.tfvars.example terraform.tfvars
3. # Éditer terraform.tfvars
4. export TF_VAR_vm_admin_password="..."
5. terraform init
6. terraform validate
7. terraform plan
8. terraform apply
9. terraform output
```

### Modification de l'infrastructure

```bash
1. # Modifier les fichiers .tf
2. terraform fmt -recursive
3. terraform validate
4. terraform plan
5. terraform apply
```

### Suppression

```bash
1. terraform plan -destroy
2. terraform destroy
```

---

## 🆘 En cas d'erreur

### Erreur d'authentification

```bash
az logout
az login
az account set --subscription "SUBSCRIPTION_ID"
```

### Erreur de state lock

```bash
# Attendre quelques minutes, puis :
terraform force-unlock LOCK_ID
```

### Erreur de nom déjà pris (Storage/WebApp)

```bash
# Changer project_name dans terraform.tfvars
# Ou supprimer et recréer
terraform destroy -target=module.storage
terraform apply -target=module.storage
```

### Infrastructure partiellement déployée

```bash
# Réappliquer (idempotent)
terraform apply

# Ou détruire et recréer
terraform destroy
terraform apply
```

---

**Dernière mise à jour** : 13 janvier 2026

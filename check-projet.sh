#!/bin/bash

# Script de vérification du projet avant soumission
# Usage: ./check-projet.sh

echo "🔍 Vérification du projet Terraform DataCorp..."
echo ""

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Compteurs
errors=0
warnings=0
success=0

# Fonction de vérification
check_file() {
    if [ -e "$1" ]; then
        echo -e "${GREEN}✓${NC} $2"
        ((success++))
        return 0
    else
        echo -e "${RED}✗${NC} $2"
        ((errors++))
        return 1
    fi
}

check_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
    ((warnings++))
}

echo "📂 Vérification de la structure des fichiers..."
echo ""

# Vérifier les fichiers principaux
check_file "provider.tf" "provider.tf existe"
check_file "main.tf" "main.tf existe"
check_file "variables.tf" "variables.tf existe"
check_file "outputs.tf" "outputs.tf existe"
check_file "terraform.tfvars.example" "terraform.tfvars.example existe"

echo ""
echo "📁 Vérification des modules..."
echo ""

# Vérifier les modules
check_file "modules/vm" "Module VM existe"
check_file "modules/vm/main.tf" "modules/vm/main.tf existe"
check_file "modules/vm/variables.tf" "modules/vm/variables.tf existe"
check_file "modules/vm/outputs.tf" "modules/vm/outputs.tf existe"

check_file "modules/storage" "Module Storage existe"
check_file "modules/storage/main.tf" "modules/storage/main.tf existe"
check_file "modules/storage/variables.tf" "modules/storage/variables.tf existe"
check_file "modules/storage/outputs.tf" "modules/storage/outputs.tf existe"

check_file "modules/webapp" "Module WebApp existe"
check_file "modules/webapp/main.tf" "modules/webapp/main.tf existe"
check_file "modules/webapp/variables.tf" "modules/webapp/variables.tf existe"
check_file "modules/webapp/outputs.tf" "modules/webapp/outputs.tf existe"

echo ""
echo "📚 Vérification de la documentation..."
echo ""

check_file "README.md" "README.md existe"
check_file ".gitignore" ".gitignore existe"

echo ""
echo "⚠️  Vérification des fichiers à NE PAS inclure..."
echo ""

# Vérifier que les fichiers sensibles n'existent pas
if [ -d ".terraform" ]; then
    check_warning "Dossier .terraform présent (à supprimer !)"
else
    echo -e "${GREEN}✓${NC} Dossier .terraform absent (OK)"
    ((success++))
fi

if ls *.tfstate >/dev/null 2>&1; then
    check_warning "Fichiers .tfstate présents (à supprimer !)"
else
    echo -e "${GREEN}✓${NC} Pas de fichiers .tfstate (OK)"
    ((success++))
fi

if [ -f "terraform.tfvars" ]; then
    check_warning "Fichier terraform.tfvars présent (sensible, à supprimer !)"
else
    echo -e "${GREEN}✓${NC} Pas de terraform.tfvars (OK)"
    ((success++))
fi

echo ""
echo "🔧 Vérification de Terraform..."
echo ""

# Vérifier si Terraform est installé
if command -v terraform &> /dev/null; then
    TF_VERSION=$(terraform version | head -n1)
    echo -e "${GREEN}✓${NC} Terraform installé ($TF_VERSION)"
    ((success++))
    
    # Vérifier le formatage
    if terraform fmt -check -recursive &> /dev/null; then
        echo -e "${GREEN}✓${NC} Code Terraform correctement formaté"
        ((success++))
    else
        check_warning "Code Terraform nécessite un formatage (terraform fmt)"
    fi
    
    # Vérifier la validation (si initialisé)
    if [ -d ".terraform" ]; then
        if terraform validate &> /dev/null; then
            echo -e "${GREEN}✓${NC} Configuration Terraform valide"
            ((success++))
        else
            echo -e "${RED}✗${NC} Configuration Terraform invalide"
            ((errors++))
        fi
    else
        check_warning "Terraform non initialisé (terraform init non exécuté)"
    fi
else
    check_warning "Terraform non installé sur ce système"
fi

echo ""
echo "📊 Statistiques du projet..."
echo ""

# Compter les fichiers
TF_FILES=$(find . -name "*.tf" | wc -l)
MD_FILES=$(find . -name "*.md" | wc -l)
TOTAL_FILES=$(find . -type f \( -name "*.tf" -o -name "*.md" -o -name "*.sh" -o -name ".gitignore" -o -name "*.example" \) | grep -v ".terraform" | wc -l)

echo "  📄 Fichiers .tf : $TF_FILES"
echo "  📚 Fichiers .md : $MD_FILES"
echo "  📦 Total fichiers : $TOTAL_FILES"

# Compter les lignes de code
if command -v wc &> /dev/null; then
    TF_LINES=$(find . -name "*.tf" -not -path "./.terraform/*" -exec wc -l {} + 2>/dev/null | tail -1 | awk '{print $1}')
    echo "  📝 Lignes de code Terraform : $TF_LINES"
fi

echo ""
echo "═══════════════════════════════════════════════════════════"
echo "                      RÉSUMÉ"
echo "═══════════════════════════════════════════════════════════"
echo ""
echo -e "${GREEN}✓ Réussis${NC}       : $success"
echo -e "${YELLOW}⚠ Avertissements${NC} : $warnings"
echo -e "${RED}✗ Erreurs${NC}        : $errors"
echo ""

if [ $errors -eq 0 ] && [ $warnings -eq 0 ]; then
    echo -e "${GREEN}🎉 PROJET PRÊT POUR LA LIVRAISON !${NC}"
    echo ""
    echo "Prochaines étapes :"
    echo "  1. ./prepare-livraison.sh"
    echo "  2. Soumettre datacorp-terraform-projet.zip sur Simplonline"
    exit 0
elif [ $errors -eq 0 ]; then
    echo -e "${YELLOW}⚠️  PROJET PRESQUE PRÊT${NC}"
    echo ""
    echo "Résoudre les avertissements avant de livrer :"
    echo "  - Exécuter ./prepare-livraison.sh pour nettoyer"
    exit 0
else
    echo -e "${RED}❌ PROJET NON PRÊT${NC}"
    echo ""
    echo "Corriger les erreurs avant de livrer !"
    exit 1
fi

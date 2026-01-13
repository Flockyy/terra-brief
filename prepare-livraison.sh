#!/bin/bash

# Script de préparation du livrable Terraform
# Usage: ./prepare-livraison.sh

set -e

echo "🧹 Nettoyage du projet Terraform..."

# Supprimer les fichiers/dossiers à ne pas inclure
echo "  ↳ Suppression du dossier .terraform..."
rm -rf .terraform

echo "  ↳ Suppression des fichiers d'état..."
rm -f *.tfstate *.tfstate.* *.tfstate.backup

echo "  ↳ Suppression du lock file..."
rm -f .terraform.lock.hcl

echo "  ↳ Suppression des fichiers de variables personnelles..."
rm -f terraform.tfvars

echo "  ↳ Suppression des fichiers système..."
find . -name ".DS_Store" -delete

echo ""
echo "✅ Nettoyage terminé !"
echo ""

# Créer l'archive ZIP
echo "📦 Création de l'archive ZIP..."

# Nom du fichier ZIP
ZIP_NAME="datacorp-terraform-projet.zip"

# Supprimer l'ancien ZIP si existant
rm -f "../$ZIP_NAME"

# Créer le ZIP
cd ..
zip -r "$ZIP_NAME" terra-brief/ \
  -x "*.terraform/*" \
  -x "*terraform.tfstate*" \
  -x "*.tfvars" \
  -x "*/.DS_Store" \
  -x "*/.git/*" \
  -x "*/prepare-livraison.sh"

cd terra-brief

echo ""
echo "✅ Archive créée : ../$ZIP_NAME"
echo ""

# Afficher la taille
ZIP_SIZE=$(du -h "../$ZIP_NAME" | cut -f1)
echo "📊 Taille de l'archive : $ZIP_SIZE"
echo ""

# Lister le contenu
echo "📋 Contenu de l'archive :"
unzip -l "../$ZIP_NAME" | head -20
echo ""

echo "🎉 Livrable prêt pour soumission !"
echo ""
echo "Le fichier se trouve ici : $(cd .. && pwd)/$ZIP_NAME"

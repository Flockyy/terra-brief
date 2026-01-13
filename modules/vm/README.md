# Module VM (Virtual Machine)

Ce module déploie une machine virtuelle Linux sur Azure avec toute l'infrastructure réseau nécessaire.

## Ressources créées

- **Virtual Network** : Réseau privé virtuel (10.0.0.0/16)
- **Subnet** : Sous-réseau pour la VM (10.0.1.0/24)
- **Public IP** : IP publique statique pour accéder à la VM
- **Network Security Group** : Pare-feu réseau avec règle SSH (port 22)
- **Network Interface** : Interface réseau de la VM
- **NSG Association** : Lie le NSG à l'interface réseau
- **Linux Virtual Machine** : VM Ubuntu 22.04 LTS

## Variables

| Nom | Type | Description | Défaut |
|-----|------|-------------|--------|
| `resource_group_name` | string | Nom du resource group | - |
| `location` | string | Région Azure | - |
| `project_name` | string | Nom du projet (préfixe) | - |
| `environment` | string | Environnement (dev/test/prod) | - |
| `vm_size` | string | Taille de la VM | - |
| `admin_username` | string | Username administrateur | - |
| `admin_password` | string | Mot de passe administrateur | - |
| `tags` | map(string) | Tags à appliquer | - |

## Outputs

| Nom | Description |
|-----|-------------|
| `vm_id` | ID de la machine virtuelle |
| `vm_name` | Nom de la machine virtuelle |
| `public_ip_address` | Adresse IP publique |
| `private_ip_address` | Adresse IP privée |
| `network_interface_id` | ID de l'interface réseau |

## Exemple d'utilisation

```hcl
module "virtual_machine" {
  source = "./modules/vm"

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  project_name        = "datacorp"
  environment         = "dev"
  vm_size             = "Standard_B1s"
  admin_username      = "azureuser"
  admin_password      = var.vm_admin_password
  tags                = var.tags
}
```

## Connexion SSH

```bash
ssh azureuser@<PUBLIC_IP>
```

## Cas d'usage Data Engineering

- Exécution de jobs Spark
- Hébergement d'Airflow
- Environnement de développement
- Testing de pipelines ETL

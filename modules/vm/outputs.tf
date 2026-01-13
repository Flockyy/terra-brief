output "vm_id" {
  description = "ID de la machine virtuelle"
  value       = azurerm_linux_virtual_machine.main.id
}

output "vm_name" {
  description = "Nom de la machine virtuelle"
  value       = azurerm_linux_virtual_machine.main.name
}

output "public_ip_address" {
  description = "Adresse IP publique de la VM"
  value       = azurerm_public_ip.main.ip_address
}

output "private_ip_address" {
  description = "Adresse IP privée de la VM"
  value       = azurerm_network_interface.main.private_ip_address
}

output "network_interface_id" {
  description = "ID de l'interface réseau"
  value       = azurerm_network_interface.main.id
}

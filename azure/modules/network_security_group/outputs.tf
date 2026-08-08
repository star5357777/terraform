output "nsg_name" {
	value = azurerm_network_security_group.security_group.name
}

output "nsg_id" {
	value = azurerm_network_security_group.security_group.id
}

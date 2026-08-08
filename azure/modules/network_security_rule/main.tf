resource "azurerm_network_security_rule" "security_rule" {
	count = length(var.priority)
	name = var.security_rule_name[count.index]
	priority = var.priority[count.index]
	direction = var.direction[count.index]
	access = var.access[count.index]
	protocol = var.protocol[count.index]
	source_port_range = var.source_port[count.index]
	destination_port_range = var.des_port[count.index]
	source_address_prefix = var.source_cidr[count.index]
	destination_address_prefix = var.des_cidr
	resource_group_name = var.rg_name
	network_security_group_name = var.nsg_name
}

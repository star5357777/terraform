resource "azurerm_subnet" "subnet" {
	count = length(var.subnet_name)
	name = var.subnet_name[count.index]
	resource_group_name = var.rg_name
	virtual_network_name = var.vnet_name
	address_prefixes = [var.subnet_cidr[count.index]]
}

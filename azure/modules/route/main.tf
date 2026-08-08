resource "azurerm_route" "route" {
	count = length(var.des_cidr)
	name = var.route_name[count.index]
	resource_group_name = var.rg_name
	route_table_name = var.route_table_name
	address_prefix = var.des_cidr[count.index]
	next_hop_type = var.next_hop[count.index]
}

resource "azurerm_route_table" "route_table" {
	name = var.route_table_name
	location = var.rg_location
	resource_group_name = var.rg_name
	disable_bgp_route_propagation = var.route_propagation
}

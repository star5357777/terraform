resource "azurerm_public_ip" "public_ip" {
	count = length(var.public_ip_name)
	name = var.public_ip_name[count.index]
	resource_group_name = var.rg_name
	location = var.rg_location
	allocation_method = "Dynamic"
}

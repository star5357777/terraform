resource "azurerm_network_interface" "nic" {
	count = length(var.nic_name)
	name = var.nic_name[count.index]
	location = var.rg_location
	resource_group_name = var.rg_name

	ip_configuration {
		name = var.nic_ip_name[count.index]
		subnet_id = "${var.subnet_id[count.index]}"
		private_ip_address_allocation = var.private_ip_launch[count.index]
		public_ip_address_id = var.public_ip_id[count.index]
	}
}
	

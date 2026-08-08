resource "azurerm_network_interface_security_group_association" "nic_nsg_association"{
	count = length(var.count_num)
	network_interface_id = "${var.nic_id[count.index]}"
	network_security_group_id = var.nsg_id
}

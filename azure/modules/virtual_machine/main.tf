resource "azurerm_virtual_machine" "virtual_machine" {
	count = length(var.nic_id)
	name = var.vm_name[count.index]
	location = var.rg_location
	resource_group_name = var.rg_name
	network_interface_ids = [var.nic_id[count.index]]
	vm_size = var.size[count.index]
	
	storage_image_reference {
		publisher = var.publisher[count.index]
		offer = var.offer[count.index]
		sku = var.sku[count.index]
		version = var.ver[count.index]
	}
	storage_os_disk {
		name = var.vm_str_name[count.index]
		caching = var.caching[count.index]
		create_option = var.create_option[count.index]
		managed_disk_type = var.managed_disk_type[count.index]
	}
	os_profile {
		computer_name = var.vm_computer_name[count.index]
		admin_username = var.vm_username[count.index]
		admin_password = var.vm_password[count.index]
	}
	os_profile_linux_config {
		disable_password_authentication = var.disable_password[count.index]
	}
}

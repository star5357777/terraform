terraform {
  required_providers {
    ncloud = {
      source = "NaverCloudPlatform/ncloud"
    }
  }
  required_version = ">= 0.13"
}

resource "ncloud_server" "server" {
	name = var.server_name
	subnet_no = var.subnet_id
	login_key_name = var.key_name
	server_image_product_code = var.image_code
	server_product_code = var.product_code
	network_interface {
		network_interface_no = var.nic_id
		order = 0
	}
}


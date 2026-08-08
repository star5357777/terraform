terraform {
  required_providers {
    ncloud = {
      source = "NaverCloudPlatform/ncloud"
    }
  }
  required_version = ">= 0.13"
}

resource "ncloud_access_control_group_rule" "acg_rule" {
	access_control_group_no = var.acg_id

	inbound {
		protocol = "TCP"
		ip_block = var.admin_ingress_cidr
		port_range = "22"
	}

	inbound {
		protocol = "TCP"
		ip_block = "0.0.0.0/0"
		port_range = "80"
	}

	inbound {
		protocol = "TCP"
		ip_block = "0.0.0.0/0"
		port_range = "443"
	}

	outbound {
		protocol = "TCP"
		ip_block = "0.0.0.0/0"
		port_range = "1-65535"
	}
}


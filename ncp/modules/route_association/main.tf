terraform {
  required_providers {
    ncloud = {
      source = "NaverCloudPlatform/ncloud"
    }
  }
  required_version = ">= 0.13"
}

resource "ncloud_route_table_association" "route_association" {
	count = length(var.subnet_id)
	subnet_no = var.subnet_id[count.index]
	route_table_no = var.route_table_id
}


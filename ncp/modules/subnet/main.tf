terraform {
  required_providers {
    ncloud = {
      source = "NaverCloudPlatform/ncloud"
    }
  }
  required_version = ">= 0.13"
}

resource "ncloud_subnet" "subnet" {
	count = length(var.subnet_cidr)
	vpc_no = var.vpc_id
	subnet = var.subnet_cidr[count.index]
	zone = var.az[count.index]
	network_acl_no = var.nacl_id
	subnet_type = var.subnet_type
	name = var.subnet_name[count.index]
	usage_type = var.subnet_usage
}

terraform {
  required_providers {
    ncloud = {
      source = "NaverCloudPlatform/ncloud"
    }
  }
  required_version = ">= 0.13"
}

resource "ncloud_network_acl" "nacl" {
	vpc_no = var.vpc_id
	name = var.nacl_name
}


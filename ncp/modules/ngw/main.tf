terraform {
  required_providers {
    ncloud = {
      source = "NaverCloudPlatform/ncloud"
    }
  }
  required_version = ">= 0.13"
}

resource "ncloud_nat_gateway" "ngw" {
	vpc_no = var.vpc_id
	zone = var.az
	name = var.ngw_name
}


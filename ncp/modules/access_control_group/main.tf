terraform {
  required_providers {
    ncloud = {
      source = "NaverCloudPlatform/ncloud"
    }
  }
  required_version = ">= 0.13"
}

resource "ncloud_access_control_group" "acg" {
	name = var.acg_name
	vpc_no = var.vpc_id
}

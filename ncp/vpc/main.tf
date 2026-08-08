terraform {
  required_providers {
    ncloud = {
      source = "NaverCloudPlatform/ncloud"
    }
  }
  required_version = ">= 0.13"
}

provider "ncloud" {
	support_vpc = true
}

module "vpc" {
	source = "../modules/vpc"
	vpc_cidr = var.vpc_cidr
	vpc_name = "vpc"
}

module "nacl" {
	source = "../modules/network_acl"
	vpc_id = module.vpc.vpc_id
	nacl_name = "test-vpc-nacl"
}

module "ngw" {
	source = "../modules/ngw"
	vpc_id = module.vpc.vpc_id
	az = "KR-1"
	ngw_name = "ngw"
}

module "public_subnet" {
	source = "../modules/subnet"
	subnet_cidr = var.public_subnet_cidrs
	vpc_id = module.vpc.vpc_id
	az = var.availability_zones
	nacl_id = module.nacl.nacl_id
	subnet_type = "PUBLIC"
	subnet_name = ["public-sub-1","public-sub-2"]
	subnet_usage = "GEN"
}

module "private_subnet" {
	source = "../modules/subnet"
	subnet_cidr = var.private_subnet_cidrs
	vpc_id = module.vpc.vpc_id
	az = var.availability_zones
	nacl_id = module.nacl.nacl_id
	subnet_type = "PRIVATE"
	subnet_name = ["private-sub-1","private-sub-2"]
	subnet_usage = "GEN"
}

module "public_route_table" {
	source = "../modules/route_table"
	vpc_id = module.vpc.vpc_id
	subnet_type = "PUBLIC"
	route_table_name = "public-rt"
}

module "private_route_table" {
	source = "../modules/route_table"
	vpc_id = module.vpc.vpc_id
	subnet_type = "PRIVATE"
	route_table_name = "private-rt"
}

module "public_route_association" {
	source = "../modules/route_association"
	subnet_id = module.public_subnet.subnet_id
	route_table_id = module.public_route_table.route_table_id
}

module "private_route_association" {
	source = "../modules/route_association"
	subnet_id = module.private_subnet.subnet_id
	route_table_id = module.private_route_table.route_table_id
}

module "private_route" {
	source = "../modules/route"
	des_cidr = "0.0.0.0/0"
	target_type = "NATGW"
	target_name = "ngw"
	target_id = module.ngw.ngw_id
	route_table_id = module.private_route_table.route_table_id
}

module "acg" {
	source ="../modules/access_control_group"
	acg_name = "acg"
	vpc_id = module.vpc.vpc_id
}

module "acg_rule" {
	source = "../modules/access_control_group/access_control_group_rule"
	acg_id = module.acg.acg_id
	admin_ingress_cidr = var.admin_ingress_cidr
}

module "nic1" {
	source = "../modules/network_interface"
	nic_name = "nic-public"
	subnet_id = module.public_subnet.subnet_id.0
	private_ip = var.public_server_private_ip
	acg_id = module.acg.acg_id
}

module "nic2" {
	source = "../modules/network_interface"
	nic_name = "nic-private"
	subnet_id = module.private_subnet.subnet_id.0
	private_ip = var.private_server_private_ip
	acg_id = module.acg.acg_id
}

module "server" {
	source = "../modules/server"
	server_name = "server"
	subnet_id = module.public_subnet.subnet_id.0
	key_name = var.login_key_name
	image_code = data.ncloud_server_image.server_image.id
	product_code = data.ncloud_server_product.product.id
	nic_id = module.nic1.nic_id
}

module "private_server" {
	source = "../modules/server"
	server_name = "private-server"
	subnet_id = module.private_subnet.subnet_id.0
	key_name = var.login_key_name
	image_code = data.ncloud_server_image.server_image.id
	product_code = data.ncloud_server_product.product.id
	nic_id = module.nic2.nic_id
}

module "server_public_ip" {
	source = "../modules/public_ip"
	server_id = module.server.server_id
}

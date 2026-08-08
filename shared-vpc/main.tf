provider "aws" {
	region = var.aws_region
}

module "vpc" {
	source = "../modules/vpc"
	vpc_cidr = "10.3.0.0/16"
	vpc_name = "shared-vpc"
}

module "private_subnet" {
	source = "../modules/subnet"
	vpc_id = module.vpc.vpc_id
	subnet_cidr = ["10.3.1.0/24","10.3.2.0/24"]
	az = ["us-west-2a","us-west-2c"]
	map_public_ip = "false"
	subnet_name = ["shared-pri-sub-a","shared-pri-sub-c"]
}

module "private_route_table" {
	source = "../modules/route_table"
	vpc_id = module.vpc.vpc_id
	route_table_name = "shared-pri-rt"
}

module "private_route_association" {
	source = "../modules/route_association"
	subnet_cidr = module.private_subnet.subnet_cidr
	subnet_id = module.private_subnet.subnet_id
	route_table_id = module.private_route_table.route_table_id
}

module "security_group" {
  source              = "../modules/security_group"
  vpc_id              = module.vpc.vpc_id
  security_group_name = "security_group"
  web_ingress_cidrs   = ["0.0.0.0/0"]
  admin_ingress_cidrs = var.admin_ingress_cidrs
}

module "tgw_attachment" {
	source = "../modules/tgw/tgw_attachment"
	vpc_id = module.vpc.vpc_id
	subnet_id = module.private_subnet.subnet_id
	tgw_id = data.aws_ec2_transit_gateway.tgw_id.id
	tgw_attachment_name = "shared-vpc-attachment"
}

module "tgw_route_association" {
	source = "../modules/tgw/tgw_route_association"
	tgw_route_table_id = data.aws_ec2_transit_gateway_route_table.tgw_route_table_id.id
	tgw_attachment_id = module.tgw_attachment.tgw_attachment_id
}

module "tgw_route_propagation" {
        source = "../modules/tgw/tgw_route_propagation"
        tgw_route_table_id = data.aws_ec2_transit_gateway_route_table.tgw_route_table_id.id
        tgw_attachment_id = module.tgw_attachment.tgw_attachment_id
}

module "private_route" {
	source = "../modules/route"
	mod_depends_on = [module.tgw_attachment]
	des_cidr = ["0.0.0.0/0","10.0.0.0/16","10.1.0.0/16","10.2.0.0/16","10.4.0.0/16"]
	gateway_id = [data.aws_ec2_transit_gateway.tgw_id.id,data.aws_ec2_transit_gateway.tgw_id.id,data.aws_ec2_transit_gateway.tgw_id.id,data.aws_ec2_transit_gateway.tgw_id.id,data.aws_ec2_transit_gateway.tgw_id.id]
	route_table_id = module.private_route_table.route_table_id
}

module "shared-pri-ec2" {
	source = "../modules/ec2"
	ami = var.ami_id
	ec2_type = "t2.micro"
	az = "us-west-2a"
	subnet_id = module.private_subnet.subnet_id.0
	key_name = var.key_name
	security_group_id = module.security_group.security_group_id
	ec2_name = "shared-pri-ec2"
}

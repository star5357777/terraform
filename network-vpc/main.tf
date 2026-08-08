provider "aws" {
	region = var.aws_region
}

module "vpc" {
	source = "../modules/vpc"
	vpc_cidr = "10.0.0.0/16"
	vpc_name = "network-vpc"
}

module "eip" {
	source = "../modules/eip"
	eip_name = "eip"
}

module "igw" {
	source = "../modules/igw"
	vpc_id = module.vpc.vpc_id
	igw_name = "igw"
}

module "ngw" {
	source = "../modules/ngw"
	eip_id = module.eip.eip_id
	public_subnet_id = module.public_subnet.subnet_id.0
	ngw_name = "ngw"
}

module "public_subnet" {
	source = "../modules/subnet"
	vpc_id = module.vpc.vpc_id
	subnet_cidr = ["10.0.1.0/24","10.0.2.0/24"]
	az = ["us-west-2a","us-west-2c"]
	map_public_ip = "true"
	subnet_name = ["net-pub-sub-a","net-pub-sub-c"]
}

module "private_subnet" {
	source = "../modules/subnet"
	vpc_id = module.vpc.vpc_id
	subnet_cidr = ["10.0.3.0/24","10.0.4.0/24"]
	az = ["us-west-2a","us-west-2c"]
	map_public_ip = "false"
	subnet_name = ["net-pri-sub-a","net-pri-sub-c"]
}

module "mgmt_subnet" {
	source = "../modules/subnet"
	vpc_id = module.vpc.vpc_id
	subnet_cidr = ["10.0.5.0/24","10.0.6.0/24"]
	az = ["us-west-2a","us-west-2c"]
	map_public_ip = "false"
	subnet_name = ["net-mgmt-sub-a","net-mgmt-sub-c"]
}

module "public_route_table" {
	source = "../modules/route_table"
	vpc_id = module.vpc.vpc_id
	route_table_name = "net-public_rt"
}

module "private_route_table" {
	source = "../modules/route_table"
	vpc_id = module.vpc.vpc_id
	route_table_name = "net-private_rt"
}

module "mgmt_route_table" {
	source = "../modules/route_table"
	vpc_id = module.vpc.vpc_id
	route_table_name = "net-mgmt_rt"
}

module "public_route_association" {
	source = "../modules/route_association"
	subnet_cidr = module.public_subnet.subnet_cidr
	subnet_id = module.public_subnet.subnet_id
	route_table_id = module.public_route_table.route_table_id
}

module "private_route_association" {
	source = "../modules/route_association"
	subnet_cidr = module.private_subnet.subnet_cidr
	subnet_id = module.private_subnet.subnet_id
	route_table_id = module.private_route_table.route_table_id
}

module "mgmt_route_association" {
	source = "../modules/route_association"
	subnet_cidr = module.mgmt_subnet.subnet_cidr
	subnet_id = module.mgmt_subnet.subnet_id
	route_table_id = module.mgmt_route_table.route_table_id
}

module "public_route" {
	source = "../modules/route"
	mod_depends_on = [module.tgw_attachment]
	des_cidr = ["0.0.0.0/0","10.1.0.0/16","10.2.0.0/16","10.3.0.0/16","10.4.0.0/16"]
	gateway_id = [module.igw.igw_id,module.tgw.tgw_id,module.tgw.tgw_id,module.tgw.tgw_id,module.tgw.tgw_id]
	route_table_id = module.public_route_table.route_table_id
}

module "private_route" {
	source = "../modules/route"
	mod_depends_on = [module.tgw_attachment]
	des_cidr = ["0.0.0.0/0","10.1.0.0/16","10.2.0.0/16","10.3.0.0/16","10.4.0.0/16"]
	gateway_id = [module.ngw.ngw_id,module.tgw.tgw_id,module.tgw.tgw_id,module.tgw.tgw_id,module.tgw.tgw_id]
	route_table_id = module.private_route_table.route_table_id
}

module "mgmt_route" {
	source = "../modules/route"
	mod_depends_on = [module.tgw_attachment]
	des_cidr = ["10.1.0.0/16","10.2.0.0/16","10.3.0.0/16","10.4.0.0/16"]
	gateway_id = [module.tgw.tgw_id,module.tgw.tgw_id,module.tgw.tgw_id,module.tgw.tgw_id]
	route_table_id = module.mgmt_route_table.route_table_id
}

module "security_group" {
  source              = "../modules/security_group"
  vpc_id              = module.vpc.vpc_id
  security_group_name = "security_group"
  web_ingress_cidrs   = ["0.0.0.0/0"]
  admin_ingress_cidrs = var.admin_ingress_cidrs
}

module "tgw" {
	source = "../modules/tgw"
	asn = "64512"
	auto_accept_shared_attachments = "disable"
	default_route_table_association = "disable"
	default_route_table_propagation = "disable"
	dns_support = "enable"
	multicast_support = "disable"
	vpn_ecmp_support = "enable"
	tgw_name = "tgw"
}

module "tgw_attachment" {
	source = "../modules/tgw/tgw_attachment"
	vpc_id = module.vpc.vpc_id
	subnet_id = module.private_subnet.subnet_id
	tgw_id = module.tgw.tgw_id
	tgw_attachment_name = "net-vpc-attachment"
}

module "tgw_route_table" {
	source = "../modules/tgw/tgw_route_table"
	tgw_id = module.tgw.tgw_id	
	tgw_route_table_name = "tgw_route_table"
}

module "tgw_route_association" {
	source = "../modules/tgw/tgw_route_association"
	tgw_attachment_id = module.tgw_attachment.tgw_attachment_id
	tgw_route_table_id = module.tgw_route_table.tgw_route_table_id
}

module "tgw_route_propagation" {
	source = "../modules/tgw/tgw_route_propagation"
	tgw_attachment_id = module.tgw_attachment.tgw_attachment_id
	tgw_route_table_id = module.tgw_route_table.tgw_route_table_id
}

module "tgw_route" {
	source = "../modules/tgw/tgw_route"
	des_cidr = "0.0.0.0/0"
	tgw_attachment_id = module.tgw_attachment.tgw_attachment_id
	tgw_route_table_id = module.tgw_route_table.tgw_route_table_id
}

module "bastion" {
	source = "../modules/ec2"
	ami = var.ami_id
	ec2_type = "t2.micro"
	subnet_id = module.public_subnet.subnet_id.0
	az = "us-west-2a"
	key_name = var.key_name
	security_group_id = module.security_group.security_group_id
	ec2_name = "bastion"
}

module "net-pri-ec2" {
	source = "../modules/ec2"
	ami = var.ami_id
	ec2_type = "t2.micro"
	subnet_id = module.private_subnet.subnet_id.1
	az = "us-west-2c"
	key_name = var.key_name
	security_group_id = module.security_group.security_group_id
	ec2_name = "net-pri-ec2"
}

module "net-mgmt-ec2" {
	source = "../modules/ec2"
	ami = var.ami_id
	ec2_type = "t2.micro"
	subnet_id = module.mgmt_subnet.subnet_id.0
	az = "us-west-2a"
	key_name = var.key_name
	security_group_id = module.security_group.security_group_id
	ec2_name = "net-mgmt-ec2"
}

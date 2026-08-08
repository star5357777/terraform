provider "aws" {
	region = var.aws_region
}

module "vpc" {
	source = "../modules/vpc"
	vpc_cidr = "10.1.0.0/16"
	vpc_name = "application-vpc"
}

module "private_subnet" {
	source = "../modules/subnet"
	vpc_id = module.vpc.vpc_id
	subnet_cidr = ["10.1.1.0/24","10.1.2.0/24"]
	az = ["us-west-2a","us-west-2c"]
	map_public_ip = "false"
	subnet_name = ["app-pri-sub-a","app-pri-sub-c"]
}

module "private_route_table" {
	source = "../modules/route_table"
	vpc_id = module.vpc.vpc_id
	route_table_name = "app-pri-rt"
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
	tgw_attachment_name = "app-vpc-attachment"
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
	des_cidr = ["0.0.0.0/0","10.0.0.0/16","10.2.0.0/16","10.3.0.0/16","10.4.0.0/16"]
	gateway_id = [data.aws_ec2_transit_gateway.tgw_id.id,data.aws_ec2_transit_gateway.tgw_id.id,data.aws_ec2_transit_gateway.tgw_id.id,data.aws_ec2_transit_gateway.tgw_id.id,data.aws_ec2_transit_gateway.tgw_id.id]
	route_table_id = module.private_route_table.route_table_id
}

module "app-pri-ec2" {
	source = "../modules/ec2"
	ami = var.ami_id
	ec2_type = "t2.micro"
	az = "us-west-2c"
	subnet_id = module.private_subnet.subnet_id.1
	key_name = var.key_name
	security_group_id = module.security_group.security_group_id
	ec2_name = "app-pri-ec2"
}

module "lb" {
	source = "../modules/lb"
	lb_name = "lb"
	lb_type = "application"
	lb_internal = "true"
	private_subnet_id = module.private_subnet.subnet_id
	security_group_id = module.security_group.security_group_id
}

module "lb_listener" {
	source = "../modules/lb/listener"
	lb_arn = module.lb.lb_arn
}

module "lb_listener_rule" {
	source = "../modules/lb_listener_rule"
	lb_listener_arn = module.lb_listener.lb_listener_arn
	lb_target_group_arn = module.lb_target_group.lb_target_group_arn
}

module "lb_target_group" {
	source = "../modules/lb_target_group"
	lb_target_group_name = "lb-target-group"
	vpc_id = module.vpc.vpc_id
	target_type = "instance"
}

module "auto_scaling_group" {
	source = "../modules/auto_scaling_group"
	template_id = module.template.template_id
	private_subnet_id = module.private_subnet.subnet_id
	min_size = 2
	max_size = 4
	auto_scaling_name = "auto_scaling"
}

module "auto_scaling_attachment" {
	source = "../modules/auto_scaling_group/auto_scaling_attachment"
	auto_scaling_group_id = module.auto_scaling_group.auto_scaling_group_id
	lb_target_group_arn = module.lb_target_group.lb_target_group_arn
}

module "template" {
	source = "../modules/templates"
	ami = var.ami_id
	ec2_type = "t2.micro"
	security_group_id = module.security_group.security_group_id
	key_name = var.key_name
}




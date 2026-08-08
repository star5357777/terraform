provider "aws" {
	region = "us-west-2"
}

resource "aws_alb" "lb" {
	name = var.lb_name
	load_balancer_type = var.lb_type
	internal = var.lb_internal
	subnets = [var.private_subnet_id.0, var.private_subnet_id.1]
	security_groups = [var.security_group_id]
}

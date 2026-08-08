provider "aws" {
	region = "us-west-2"
}

resource "aws_lb_target_group" "lb_target_group" {
	name = var.lb_target_group_name
	port = 80
	protocol = "HTTP"
	vpc_id = var.vpc_id
	target_type = var.target_type	

	health_check {
		path = "/"
		protocol = "HTTP"
		matcher = "200"
		interval = 15
		timeout = 3
		healthy_threshold = 2
		unhealthy_threshold = 2
	}
}


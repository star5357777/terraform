provider "aws" {
	region = "us-west-2"
}

resource "aws_autoscaling_group" "auto_scaling" {
	launch_configuration = var.template_id
	vpc_zone_identifier = var.private_subnet_id
	
	health_check_type = "ELB"
	
	min_size = var.min_size
	max_size = var.max_size

	tag {
		key = "Name"
		value = var.auto_scaling_name
		propagate_at_launch = true
	}
}

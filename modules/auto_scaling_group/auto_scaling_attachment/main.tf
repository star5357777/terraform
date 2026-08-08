provider "aws" {
	region = "us-west-2"
}

resource "aws_autoscaling_attachment" "auto_scaling_attachment" {
	autoscaling_group_name = var.auto_scaling_group_id
	lb_target_group_arn = var.lb_target_group_arn
}

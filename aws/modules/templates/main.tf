provider "aws" {
	region = "us-west-2"
}

resource "aws_launch_configuration" "template" {
	image_id = var.ami
	instance_type = var.ec2_type
	security_groups = [var.security_group_id]
	user_data = file("${path.module}/user-data.sh")
	key_name = var.key_name
}

provider "aws" {
	region = "us-west-2"
}

resource "aws_instance" "ec2" {
	ami = var.ami
	instance_type = var.ec2_type
	availability_zone = var.az
	subnet_id = var.subnet_id
	key_name = var.key_name
	vpc_security_group_ids = [var.security_group_id]
	tags = {
		Name = var.ec2_name
	}
}

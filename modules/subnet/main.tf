provider "aws" {
	region = "us-west-2"
}

resource "aws_subnet" "subnet" {
	count = length(var.subnet_cidr)
	vpc_id = var.vpc_id
	cidr_block = var.subnet_cidr[count.index]
	availability_zone = var.az[count.index]
	map_public_ip_on_launch = var.map_public_ip
	tags = {
		Name = var.subnet_name[count.index]
	}
}

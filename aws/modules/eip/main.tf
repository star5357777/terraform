provider "aws" {
	region = "us-west-2"
}

resource "aws_eip" "eip" {
	vpc = true
	tags = {
		Name = var.eip_name
	}
}

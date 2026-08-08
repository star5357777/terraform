provider "aws" {
	region = "us-west-2"
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_attachment" {
	vpc_id = var.vpc_id
	subnet_ids = ["${var.subnet_id.0}","${var.subnet_id.1}"]
	transit_gateway_id = var.tgw_id
	tags = {
		Name = var.tgw_attachment_name
	}
}

provider "aws" {
	region = "us-west-2"
}

resource "aws_ec2_transit_gateway_route_table" "tgw_route_table" {
	transit_gateway_id = var.tgw_id
	tags = {
		Name = var.tgw_route_table_name
	}
}

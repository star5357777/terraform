data "aws_ec2_transit_gateway" "tgw_id" {
	filter {
		name = "tag:Name"
		values = ["tgw"]
	}
	filter {
		name = "state"
		values = ["available"]
	}
}

data "aws_ec2_transit_gateway_route_table" "tgw_route_table_id" {
	filter {
		name = "tag:Name"
		values = ["tgw_route_table"]
	}
}

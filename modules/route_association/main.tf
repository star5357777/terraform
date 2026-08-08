provider "aws" {
	region = "us-west-2"
}

resource "aws_route_table_association" "route_association" {
	count = length(var.subnet_cidr)
	subnet_id = "${var.subnet_id[count.index]}"
	route_table_id = var.route_table_id
}

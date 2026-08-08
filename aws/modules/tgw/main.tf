provider "aws" {
	region = "us-west-2"
}

resource "aws_ec2_transit_gateway" "tgw" {
	amazon_side_asn = var.asn
	auto_accept_shared_attachments = var.auto_accept_shared_attachments
	default_route_table_association = var.default_route_table_association
	default_route_table_propagation = var.default_route_table_propagation
	dns_support= var.dns_support
	multicast_support = var.multicast_support
	vpn_ecmp_support = var.vpn_ecmp_support
	tags = {
		Name = var.tgw_name
	}
}

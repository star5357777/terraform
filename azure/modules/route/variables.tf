variable "des_cidr" {
	type = list(string)
}

variable "rg_name" {
	type = string
}

variable "route_name" {
	type = list(string)
}

variable "route_table_name" {
	type = string
}

variable "next_hop" {
	type = list(string)
}

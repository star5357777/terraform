variable "vpc_id" {
	type = string
}

variable "subnet_cidr" {
	type = list(string)
}

variable "az" {
	type = list(string)
}

variable "subnet_name" {
	type = list(string)
}

variable "map_public_ip" {
	type = string
}

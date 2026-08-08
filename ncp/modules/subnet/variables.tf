variable "subnet_cidr" {
	type = list(string)
}

variable "vpc_id" {
	type = string
}

variable "az" {
	type = list(string)
}

variable "nacl_id" {
	type = string
}

variable "subnet_type" {
	type = string
}

variable "subnet_name" {
	type = list(string)
}

variable "subnet_usage" {
	type = string
}

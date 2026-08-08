variable "nic_name" {
	type = list(string)
}

variable "rg_location" {
	type = string
}

variable "rg_name" {
	type = string
}

variable "nic_ip_name" {
	type = list(string)
}

variable "subnet_id" {
	type = list(string)
}

variable "private_ip_launch" {
	type = list(string)
}

variable "public_ip_id" {
	type = list(string)
}

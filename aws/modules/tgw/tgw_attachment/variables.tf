variable "vpc_id" {
	type = string
}

variable "subnet_id" {
	type = list(string)
}

variable "tgw_id" {
	type = string
}

variable "tgw_attachment_name" {
	type = string
}

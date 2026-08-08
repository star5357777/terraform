variable "template_id" {
	type = string
}

variable "private_subnet_id" {
	type = list(string)
}

variable "min_size" {
	type = string
}

variable "max_size" {
	type = string
}

variable "auto_scaling_name" {
	type = string
}

variable "security_rule_name" {
	type = list(string)
}

variable "priority" {
	type = list(number)
}

variable "direction" {
	type = list(string)
}

variable "protocol" {
	type = list(string)
}
variable "source_port" {
	type = list(string)
}

variable "des_port" {
	type = list(string)
}

variable "source_cidr" {
	type = list(string)
}

variable "des_cidr" {
	type = string
}

variable "rg_name" {
	type = string
}

variable "nsg_name" {
	type = string
}

variable "access" {
	type = list(string)
}

variable "rg_location" {
	type = string
}

variable "rg_name" {
	type = string
}

variable "vm_name" {
	type = list(string)
}

variable "size" {
	type = list(string)
}

variable "nic_id" {
	type = list(string)
}

variable "publisher" {
	type = list(string)
}

variable "offer" {
	type = list(string)
}

variable "sku" {
	type = list(string)
}

variable "ver" {
	type = list(string)
}

variable "vm_str_name" {
	type = list(string)
}

variable "caching" {
	type = list(string)
}

variable "create_option" {
	type = list(string)
}

variable "managed_disk_type" {
	type = list(string)
}

variable "vm_computer_name" {
	type = list(string)
}

variable "vm_username" {
	type = list(string)
}

variable "vm_password" {
	type = list(string)
}

variable "disable_password" {
	type = list(bool)
}

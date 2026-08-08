variable "vpc_id" {
  type = string
}

variable "security_group_name" {
  type = string
}

variable "web_ingress_cidrs" {
  description = "CIDR blocks allowed to access HTTP/HTTPS."
  type        = list(string)
}

variable "admin_ingress_cidrs" {
  description = "CIDR blocks allowed to access administrative ports such as SSH and ICMP."
  type        = list(string)
}

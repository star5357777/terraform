variable "vpc_cidr" {
  description = "CIDR block for the NCP VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets."
  type        = list(string)
  default     = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets."
  type        = list(string)
  default     = ["10.0.2.0/24", "10.0.3.0/24"]
}

variable "availability_zones" {
  description = "NCP availability zones used by the example."
  type        = list(string)
  default     = ["KR-1", "KR-2"]
}

variable "public_server_private_ip" {
  description = "Example private IP for the public-subnet server NIC."
  type        = string
  default     = "10.0.0.6"
}

variable "private_server_private_ip" {
  description = "Example private IP for the private-subnet server NIC."
  type        = string
  default     = "10.0.2.6"
}

variable "login_key_name" {
  description = "Existing NCP login key name. Override for your environment."
  type        = string
  default     = "portfolio-example-key"
}

variable "admin_ingress_cidr" {
  description = "CIDR allowed to access SSH. Override with a trusted admin network."
  type        = string
  default     = "10.0.0.0/8"
}

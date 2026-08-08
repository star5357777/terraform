variable "vm_admin_password" {
  description = "Azure VM administrator password. Supply securely at runtime; do not commit tfvars containing this value."
  type        = string
  sensitive   = true
}

variable "admin_ingress_cidr" {
  description = "CIDR allowed to access the VM over SSH."
  type        = string
  default     = "10.0.0.0/8"
}

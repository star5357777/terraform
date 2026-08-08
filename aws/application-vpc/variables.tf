variable "aws_region" {
  description = "AWS region used by this example environment."
  type        = string
  default     = "us-west-2"
}

variable "ami_id" {
  description = "AMI ID for EC2 instances. Replace with an AMI available in your account/region."
  type        = string
  default     = "ami-0123456789abcdef0"
}

variable "key_name" {
  description = "Existing EC2 key pair name. Do not commit private key material."
  type        = string
  default     = "portfolio-key"
}

variable "admin_ingress_cidrs" {
  description = "Administrative access CIDRs for SSH/ICMP. Restrict this for real environments."
  type        = list(string)
  default     = ["10.0.0.0/8"]
}

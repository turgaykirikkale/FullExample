variable "vpc_name" {
  type = string
  description = "Name of VPC"
}

variable "vpc_cidr_block" {
  description = "IPv4 CIDR range to assign to VPC if creating VPC or to associate as a secondary IPv6 CIDR. Overridden by var.vpc_id output from data.aws_vpc."
  type        = string
}
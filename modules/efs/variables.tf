variable "vpc_id" {
  description = "The VPC ID where the EFS will be created"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs in each AZ for creating EFS mount targets"
  type        = list(string)
}

variable "security_group_id" {
  description = "The security group that allows EC2 instances to access EFS"
  type        = string
}

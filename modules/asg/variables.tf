variable "template_name" {
  description = "Launch configuration name"
  type        = string
}

variable "ami_id" {
  description = "AMI ID"
  type        = string
}

variable "instance_type" {
  description = "Instance type"
  type        = string
}

variable "security_groups" {
  description = "List of security groups to associate with the instances"
  type        = list(string)
}

variable "desired_capacity" {
  description = "Desired capacity of resources"
  type        = number
  default     = 2
}
variable "max_size" {
  description = "Max size of resources"
  type        = number
  default     = 5
}
variable "min_size" {
  description = "Min size of resources"
  type        = number
  default     = 1
}
variable "subnet_ids" {
  description = "Subent IDs"
  type        = list(string)
}
variable "health_check_type" {
  description = "Health check type"
  type        = string
  default     = "EC2"
}

variable "asg_name" {
  description = "ASG name"
  type        = string
}
variable "target_group_arn" {
  description = "ELB target group arns"
  type        = list(string)
  default     = []
}

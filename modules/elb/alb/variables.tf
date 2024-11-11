variable "lb_name" {
  description = "The name of the ALB"
  type        = string
}

variable "subnets" {
  description = "List of subnet IDs where ALB should be deployed"
  type        = list(string)
}

variable "security_group" {
  description = "Security Group List"
  type        = list(string)
}

variable "vpc_id" {
  description = "vpc_id"
  type        = string
}

variable "attachment_ids" {
  description = "Attachments ids"
  type        = list(string)
  default     = []
}

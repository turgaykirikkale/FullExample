variable "nlb_name" {
  description = "Network load balancer name"
  type        = string
}

variable "subnet_ids" {
  description = "Subnets IDs for NLB"
  type        = list(string)
}

variable "vpc_id" {
  description = "Vpc id"
  type        = string
}

variable "enable_deletion_protection" {
  description = "Enable deletion protection for NLB"
  type        = bool
  default     = false
}
variable "security_group_id" {
  description = "Security Groups"
  type        = list(string)
}
variable "target_group_name" {
  description = "Target group name"
  type        = string
}
variable "target_group_port" {
  description = "Target group port the target group"
  type        = number
}
variable "target_group_protocol" {
  description = "The protocol for the target group"
  type        = string
  default     = "TCP"
}
variable "target_type" {
  description = "The type of target (instance, ip or Lambda)"
  type        = string
  default     = "instance"
}
variable "health_check_protocol" {
  description = "The protocol for health check"
  type        = string
  default     = "TCP"
}
variable "health_check_interval" {
  description = "The interval for health checks in seconds"
  type        = number
  default     = 45
}

variable "health_check_timeout" {
  description = "The timeout for health checks in seconds"
  type        = number
  default     = 5
}
variable "health_check_healthy_threshold" {
  description = "The number of healthy checks before considering the target healthy"
  type        = number
  default     = 3
}
variable "health_check_unhealthy_threshold" {
  description = "The number of health checks before considering the target unhealthy"
  type        = number
  default     = 3
}

variable "listener_port" {
  description = "The port for the listener"
  type        = number
  default     = 80
}

variable "listener_protocol" {
  description = "The protocol for the listener"
  type        = string
  default     = "TCP"
}

variable "attachment_ids" {
  description = "Attachments ids"
  type        = list(string)
  default     = []
}


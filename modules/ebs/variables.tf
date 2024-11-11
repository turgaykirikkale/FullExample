variable "availability_zone" {
  type        = string
  description = "The AZ where the EBS volume will be created"
}
variable "volume_size" {
  type        = number
  description = "The size of the EBS volume in GB"
  default     = 1
}

variable "volume_name" {
  type        = string
  description = "The name of the EBS volume"
  default     = "example-ebs-volume"
}

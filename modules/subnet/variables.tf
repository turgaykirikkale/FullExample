variable "vpc_id" {

  type        = string
  description = "VPC ID"
}

variable "cidr_block" {
  type        = string
  default     = null
  description = "Base CIDR block which is divided into subnet CIDR blocks (e.g. `10.0.0.0/16`)."
}

variable "availability_zone" {
  type        = string
  description = "Zone"
}
variable "name" {
  type        = string
  description = "Name of the Subnet"
}
variable "environment" {
  type        = string
  description = "Name of the environment"
}
variable "map_public_ip_on_launch" {
  type    = bool
  default = false
}

variable "sg_name" {
  type        = string
  description = "Name of the security group"
}

variable "description" {
  description = "A description of the security group"
  type        = string
}

variable "vpc_id" {
  type        = string
  description = "VPC id"
}

variable "ingress_from_port" {
  type = number
}
variable "ingress_to_port" {
  type = number
}
variable "ingress_protocol" {
  type = string
}
variable "ingress_cidr_blocks" {
  type    = list(string)
  default = []
}
variable "ingress_sg" {
  type    = list(string)
  default = []
}
variable "engress_from_port" {
  type    = number
  default = 0
}
variable "engress_to_port" {
  type    = number
  default = 0
}
variable "engress_protocol" {
  type    = string
  default = "-1"
}
variable "engress_cidr_blocks" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}


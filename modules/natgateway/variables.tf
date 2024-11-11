variable "public_subnet_ids" {
  description = "List of Public Subnet IDs to place NAT Gateways"
  type        = list(string)
}

variable "tags" {
  type        = map(string)
  description = "Optional tags for resources"
  default     = {}
}

variable "internet_gateway" {
  type        = string
  description = "InternetGateway Info"
}

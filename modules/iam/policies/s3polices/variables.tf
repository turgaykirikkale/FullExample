variable "s3_bucket_arn" {
  type        = string
  description = "S3 Bucket arn"
}

variable "allowed_ips" {
  type        = list(string)
  description = "Specific IPs for reaching S3 Bucket"
  default = [
    "192.168.1.1/32",
    "203.0.113.0/24"
  ]
}

variable "role_id" {
  type        = number
  description = "Role Name"
  default     = null
}

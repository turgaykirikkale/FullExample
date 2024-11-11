variable "source_bucket_name" {
  type        = string
  description = "Name of the source S3 bucket"
}
variable "source_bucket_arn" {
  type = string
  description = "Arn of the source S3 bucket"
}
variable "source_bucket_id" {
  type = string
  description = "ID of the source S3 bucket"
}

variable "source_region" {
  type = string
  description = "Source Region"
  default = "us-east-1"
}

variable "destination_bucket_name" {
  type        = string
  description = "Name of the destination S3 bucket"
}

variable "destination_region" {
  type        = string
  description = "AWS region of the destination bucket"
  default     = "us-west-2"
}


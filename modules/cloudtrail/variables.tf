variable "trail_name" {
  description = "CloudTrail name"
  type        = string

}
variable "s3_bucket_name" {
  description = "S3 bucket name"
  type        = string
}

variable "is_multi_region_trail" {
  description = "Is multi region"
  type        = bool
  default     = true
}

variable "include_global_service_events" {
  description = "Include global service"
  type        = bool
  default     = true
}

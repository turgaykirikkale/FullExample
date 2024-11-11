variable "bucket_name" {
  type        = string
  description = "Bucket Name"
}

variable "versioning" {
  type        = bool
  description = "Versioning control by variable"
  default     = false
}

# Public Access Blocking değişkenleri
variable "block_public_acls" {
  description = "Whether to block public ACLs"
  type        = bool
  default     = false
}

variable "ignore_public_acls" {
  description = "Whether to ignore public ACLs"
  type        = bool
  default     = false
}

variable "block_public_policy" {
  description = "Whether to block public policies"
  type        = bool
  default     = false
}

variable "restrict_public_buckets" {
  description = "Whether to restrict public bucket policies"
  type        = bool
  default     = false
}

variable "sns_topic_arn" {
  description = "The ARN of the SNS topic for S3 event notifications"
  type        = string
  default     = null
}

variable "s3_events" {
  description = "List of S3 event types to enable notifications for"
  type        = list(string)
  default = [
    "s3:ObjectCreated:*",
    "s3:ObjectRemoved:*",
    "s3:ObjectRestore:*",
    "s3:Replication:*",
    "s3:LifecycleTransition",
    "s3:ReducedRedundancyLostObject"
  ]
}

variable "notification_email" {
  description = "The email address for receiving SNS notifications (optional)"
  type        = string
  default     = null
}

variable "sns_topic_name" {
  description = "SNS topic name for S3 event notifications (optional)"
  type        = string
  default     = null
}

variable "s3_bucket_arn" {
  description = "The ARN of the S3 bucket allowed to publish to SNS (optional)"
  type        = string
  default     = null
}

variable "notification_email" {
  description = "The email address for receiving SNS notifications (optional)"
  type        = string
  default     = null
}
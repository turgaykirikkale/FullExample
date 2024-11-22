variable "queue_name" {
  description = "The name of SQS queue"
  type        = string
}

variable "message_retention_seconds" {
  description = "The length of time (in seconds) that Amazon SQS retains a message"
  type        = number
  default     = 86400 # Default: 1 day
}

variable "visibility_timeout_seconds" {
  description = "The duration (in seconds) that the received messages are hidden from subsequent retrieve requests after being retrieved by a ReceiveMessage request"
  type        = number
  default     = 60
}

variable "delay_seconds" {
  description = "The time in seconds to delay the message"
  type        = number
  default     = 0
}

variable "max_message_size" {
  description = "The limit of how large a message can be in bytes"
  type        = number
  default     = 262144 # 256 KB
}


variable "kms_master_key_id" {
  description = "The KMS key ID to encrypt the SQS queue messages"
  type        = string
  default     = "alias/aws/sqs"
}

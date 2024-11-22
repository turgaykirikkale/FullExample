variable "name" {
  description = "Name of the stream"
  type        = string
}
variable "shard_count" {
  description = "Shard count"
  type        = number
  default     = 1
}

variable "shard_level_metrics" {
  description = "Shard Level Metrics"
  type        = list(string)
}

variable "retention_period" {
  description = "Retention period"
  type        = number
  default     = 48
}

variable "stream_mode" {
  description = "Stream mode"
  type        = string
}
variable "environment" {
  description = "Environment"
  type        = string
}

variable "alarm_name" {
  description = "Name of the CloudWatch alarm"
  type        = string
}

variable "comparison_operator" {
  description = "The comparison operator for the metric"
  type        = string
  default     = "GreaterThanThreshold"
}

variable "evaluation_periods" {
  description = "Number of periods over which data is evaluated"
  type        = number
  default     = 1
}

variable "metric_name" {
  description = "The metric to monitor"
  type        = string
}

variable "namespace" {
  description = "The namespace of the metric"
  type        = string
}

variable "period" {
  description = "The granularity, in seconds, of the returned data points"
  type        = number
  default     = 60
}

variable "statistic" {
  description = "The statistic for the metric"
  type        = string
  default     = "Average"
}

variable "threshold" {
  description = "The threshold for the alarm"
  type        = number
}

variable "alarm_description" {
  description = "Description for the alarm"
  type        = string
}

variable "dimensions" {
  description = "Dimensions for the metric"
  type        = map(string)
  default     = {}
}

variable "alarm_actions" {
  description = "List of actions to take when alarm is triggered"
  type        = list(string)
}
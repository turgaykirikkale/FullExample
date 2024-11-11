variable "placement_group_name" {
  description = "The name of the placement group to associate with"
  type        = string
  default     = "" # By default, it can be empty (placement group may not be present).
}

variable "placement_group_strategy" {
  description = "The strategy for the placement group (cluster, spread, partition)"
  type        = string
  default     = "cluster" # by default cluster
}
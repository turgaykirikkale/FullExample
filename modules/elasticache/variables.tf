variable "name" {
  description = "Name of the Elasticache"
  type        = string
}
variable "cluster_id" {
  description = "ElastiCache converts this name to lowercase. Changing this value will re-create the resource."
  type        = string
  default     = "Cluster-example"
}
variable "engine" {
  description = " (Optional, Required if replication_group_id is not specified) Name of the cache engine to be used for this cache cluster. Valid values are memcached and redis"
  type        = string
  default     = "redis"
}
variable "node_type" {
  description = "Required unless replication_group_id is provided) The instance class used. See AWS documentation for information on supported node types for Redis and guidance on selecting node types for Redis. See AWS documentation for information on supported node types for Memcached and guidance on selecting node types for Memcached. For Memcached, changing this value will re-create the resource."
  type        = string
  default     = "cahce.t3.micro"
}
variable "num_cache_nodes" {
  description = "Required unless replication_group_id is provided) The initial number of cache nodes that the cache cluster will have. For Redis, this value must be 1. For Memcached, this value must be between 1 and 40. If this number is reduced on subsequent runs, the highest numbered nodes will be removed"
  type        = number
  default     = 1
}

variable "parameter_group_name" {
  description = "(Required unless replication_group_id is provided) The name of the parameter group to associate with this cache cluster."
  type        = string
  default     = "default.redis6.x"
}

variable "apply_immediately" {
  description = " (Optional) Whether any database modifications are applied immediately, or during the next maintenance window. Default is false. See Amazon ElastiCache Documentation for more information.."
  type        = bool
  default     = false
}

variable "availability_zone" {
  description = " (Optional) Availability Zone for the cache cluster. If you want to create cache nodes in multi-az, use preferred_availability_zones instead. Default: System chosen Availability Zone. Changing this value will re-create the resource."
  type        = list(string)
  default     = []
}

variable "az_mode" {
  description = " (Optional, Memcached only) Whether the nodes in this Memcached node group are created in a single Availability Zone or created across multiple Availability Zones in the cluster's region. Valid values for this parameter are single-az or cross-az, default is single-az. If you want to choose cross-az, num_cache_nodes must be greater than 1."
  type        = string
  default     = "single-az"
}

variable "final_snapshot_identifier" {
  description = " (Optional, Redis only) Name of your final cluster snapshot. If omitted, no final snapshot will be made."
  type        = string
  default     = "Null_snapshot"
}

variable "log_delivery_configuration" {
  description = " (Optional, Redis only) Specifies the destination and format of Redis SLOWLOG or Redis Engine Log. See the documentation on Amazon ElastiCache. See Log Delivery Configuration below for more details."
  type = object({
    destination      = string
    destination_type = string
    log_format       = string
    log_type         = string
  })
  default = null
}

variable "maintenance_window" {
  description = "(Optional) Specifies the weekly time range for when maintenance on the cache cluster is performed. The format is ddd:hh24:mi-ddd:hh24:mi (24H Clock UTC). The minimum maintenance window is a 60 minute period. Example: sun:05:00-sun:09:00."
  type        = string
  default     = "sun:05:00-sun:09:00"
}

variable "notification_topic_arn" {
  description = "(Optional) ARN of an SNS topic to send ElastiCache notifications to. Example: arn:aws:sns:us-east-1:012345678999:my_sns_topic."
  type        = string
  default     = null
}
variable "preferred_availability_zones" {
  description = " (Optional, Memcached only) List of the Availability Zones in which cache nodes are created. If you are creating your cluster in an Amazon VPC you can only locate nodes in Availability Zones that are associated with the subnets in the selected subnet group. The number of Availability Zones listed must equal the value of num_cache_nodes. If you want all the nodes in the same Availability Zone, use availability_zone instead, or repeat the Availability Zone multiple times in the list. Default: System chosen Availability Zones. Detecting drift of existing node availability zone is not currently supported. Updating this argument by itself to migrate existing node availability zones is not currently supported and will show a perpetual difference."
  type        = list(string)
  default     = []

}

variable "replication_group_id" {
  description = " (Optional, Required if engine is not specified) ID of the replication group to which this cluster should belong. If this parameter is specified, the cluster is added to the specified replication group as a read replica; otherwise, the cluster is a standalone primary that is not part of any replication group."
  type        = string
  default     = "null"
}
variable "security_group_ids" {
  description = "(Optional, VPC only) One or more VPC security groups associated with the cache cluster. Cannot be provided with replication_group_id."
  type        = list(string)
  default     = []
}

variable "subnet_group_name" {
  description = " (Optional, VPC only) Name of the subnet group to be used for the cache cluster. Changing this value will re-create the resource. Cannot be provided with replication_group_id."
  type        = string
  default     = null
}
variable "subnet_group_ids" {
  description = "Subnet groups IDs"
  type        = list(string)
  default     = []
}

variable "transit_encryption_enabled" {
  description = "(Optional) Enable encryption in-transit. Supported only with Memcached versions 1.6.12 and later, running in a VPC. See the ElastiCache in-transit encryption documentation for more details."
  type        = bool
  default     = false
}

variable "engine_version" {
  description = "(Optional) Version number of the cache engine to be used. If not set, defaults to the latest version. See Describe Cache Engine Versions in the AWS Documentation for supported versions. When engine is redis and the version is 7 or higher, the major and minor version should be set, e.g., 7.2. When the version is 6, the major and minor version can be set, e.g., 6.2, or the minor version can be unspecified which will use the latest version at creation time, e.g., 6.x. Otherwise, specify the full version desired, e.g., 5.0.6. The actual engine version used is returned in the attribute engine_version_actual, see Attribute Reference below. Cannot be provided with replication_group_id."
  type        = string
  default     = "3.2.10"
}

variable "port" {
  description = "port of the elasticache"
  type        = number
  default     = 6379
}

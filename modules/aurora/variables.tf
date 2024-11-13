variable "cluster_identifier" {
  description = "Cluster identifier"
  type        = string
}
variable "engine" {
  description = "Cluster engine"
  type        = string
}

variable "engine_version" {
  description = "Engine version"
  type        = string

}

variable "db_cluster_instance_class" {
  description = "Cluster instance class"
  type        = string
  default     = "t3.micro"
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}
variable "db_name" {
  description = "Database name"
  type        = string
}

variable "master_username" {
  description = "Master username"
  type        = string
}

variable "master_password" {
  description = "Must be 8 characters password"
  type        = string
}
variable "backup_retention_period" {
  description = "Backup retention period"
  type        = number
  default     = 5
}

variable "preferred_backup_window" {
  description = "Preferred backup window"
  type        = string
  default     = "07:00-09:00"
}
variable "sg_aurora" {
  description = "Security Group"
  type        = list(string)
}

variable "db_subnet_group_name" {
  description = "Subnet group name"
  type        = string
  default     = "aurora_default_subnet_group_name"
}

variable "subnet_ids" {
  description = "Subnet IDs"
  type = list(string)
  
}

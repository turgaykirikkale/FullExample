variable "engine" {
  description = "Database engine (e.g, mysql, postgres ..)"
  type        = string
}
variable "engine_version" {
  description = "Engine Version"
  type        = string
}
variable "instance_class" {
  description = "Instance class (e.g. db.t3.micro ...)"
  type        = string
}
variable "replica_instance_class" {
  description = "Read replica için instance türü"
  type        = string
}

variable "db_name" {
  description = "Name of database"
  type        = string
}
variable "username" {
  description = "Database admin username"
  type        = string
}
variable "password" {
  description = "Database admin password"
  type        = string
  sensitive   = true
}

variable "allocated_storage" {
  description = "Allocated storage in GB"
  type        = number
  default     = 20
}
variable "multi_Az" {
  description = "Enable multi-az deployment"
  type        = bool
  default     = false
}
variable "publicly_accessible" {
  description = "Whether the database is publicly accessible"
  type        = bool
  default     = true
}

variable "skip_final_snapshot" {
  description = "Whether to skip final snapshot before deletion"
  type        = bool
  default     = true
}

/*
variable "parameter_group_name" {
  description = "Database parameter group name"
  type        = string
}
*/

variable "security_group_id" {
  description = "Subnet IDs for the database"
  type        = list(string)
}

variable "subnet_ids" {
  description = "Subnet IDs for the database"
  type        = list(string)
}

variable "name" {
  description = "Name of the RDS instance"
  type        = string
}

variable "db_subnet_group_name" {
  description = "Name of the DB subnet group"
  type        = string
  default     = "my_db_subnet_group"
}

variable "replica_count" {
  description = "Oluşturulacak read replica sayısı"
  type        = number
  default     = 1
}

variable "availability_zones" {
  description = "Replicas AZ"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

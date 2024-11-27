variable "cluster_identifier" {
  description = "The Redshift cluster identifier"
  type        = string
}

variable "node_type" {
  description = "The node type for the Redshift cluster"
  type        = string
}

variable "master_username" {
  description = "Master username for the Redshift cluster"
  type        = string
}

variable "master_password" {
  description = "Master password for the Redshift cluster"
  type        = string
  sensitive   = true
}

variable "cluster_type" {
  description = "Type of the cluster (single-node or multi-node)"
  type        = string
}

variable "database_name" {
  description = "The name of the first database to be created when the cluster is created"
  type        = string
}

variable "port" {
  description = "Port to connect to the cluster"
  type        = number
}

variable "iam_roles" {
  description = "IAM roles associated with the Redshift cluster"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs to associate with the cluster"
  type        = list(string)
}

variable "subnet_group_name" {
  description = "Name of the Redshift subnet group"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the Redshift subnet group"
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "volume_id" {
  description = "ID of the EBS volume to create a snapshot for"
  type        = string
}

variable "description" {
  description = "Description for the EBS snapshot"
  type        = string
  default     = "EBS Snapshot created by Terraform"
}

variable "encrypted" {
  description = "Whether to encrypt the snapshot or not"
  type        = bool
  default     = false
}

variable "create_volume_from_snapshot" {
  description = "Set to true if you want to create a volume from this snapshot"
  type        = bool
  default     = false
}

variable "size" {
  description = "Size of the new volume created from the snapshot, in GiB"
  type        = number
  default     = 1
}

variable "availability_zone" {
  description = "Availability Zone for the new EBS volume"
  type        = string
  default     = "us-east-1a"
}

variable "snapshot_name" {
  description = "Name to assign to the snapshot and the created volume"
  type        = string

}

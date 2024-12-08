variable "compute_environment_name" {
  description = "Name of the Batch compute environment"
  type        = string
  default     = "my-batch-environment"
}

variable "min_vcpus" {
  description = "Minimum vCPUs in the compute environment"
  type        = number
  default     = 0
}

variable "max_vcpus" {
  description = "Maximum vCPUs in the compute environment"
  type        = number
  default     = 16
}

variable "instance_types" {
  description = "Instance types for the compute environment"
  type        = list(string)
  default     = ["t2.micro"]
}

variable "subnets" {
  description = "List of subnet IDs for the compute environment"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs for the compute environment"
  type        = list(string)
}

variable "instance_role" {
  description = "Instance role for the Batch compute environment"
  type        = string
}

variable "service_role" {
  description = "Service role for AWS Batch"
  type        = string
}

variable "job_queue_name" {
  description = "Name of the Batch job queue"
  type        = string
  default     = "my-job-queue"
}

variable "job_queue_priority" {
  description = "Priority of the Batch job queue"
  type        = number
  default     = 1
}

variable "job_definition_name" {
  description = "Name of the Batch job definition"
  type        = string
  default     = "my-job-definition"
}

variable "container_image" {
  description = "Docker image to use for the job"
  type        = string
  default     = "busybox"
}

variable "vcpus" {
  description = "vCPUs required for the job"
  type        = number
  default     = 1
}

variable "memory" {
  description = "Memory (in MiB) required for the job"
  type        = number
  default     = 512
}

variable "command" {
  description = "Command to run inside the container"
  type        = list(string)
  default     = ["echo", "Hello, AWS Batch!"]
}

variable "cloud_formation_name" {
  description = "Cloud formation name"
  type        = string
  default     = "Cloud_ex"
}

variable "parameters" {
  description = "Parameters of Cloud Formation"
  type = object({
    InstanceName     = string,
    InstanceType     = string,
    KeyName          = string,
    MinInstanceCount = number,
    MaxInstanceCount = number,
    VPCId            = string
    PublicSubnet1    = string
    PublicSubnet2    = string
  })
  default = {
    InstanceName     = "a",
    InstanceType     = "a",
    KeyName          = "a",
    MinInstanceCount = 1,
    MaxInstanceCount = 2,
    VPCId            = "a"
    PublicSubnet1    = "a"
    PublicSubnet2    = "a"
  }
}

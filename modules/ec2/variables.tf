variable "ami_name" {
  description = "The AMI nameter"
  type        = string
  default     = "amazon_linux"
}
variable "ami_map" {
  description = "AMI's IDs with AMI's Name"
  type        = map(string)
  default = {
    #we can add more here for AMI
    "amazon_linux" = "ami-063d43db0594b521b"
    "ubuntu"       = "ami-0dba2cb6798deb6d8"
    "windows"      = "ami-0b69ea66ff7391e80"
    "rhel"         = "ami-0cda377a1b884a1bc"
    "centos"       = "ami-052efd3df9dad4825"
    "sles"         = "ami-0dba2cb6798deb6d8"
  }
}

variable "custom_ami_id" {
  description = "Custom ami id"
  type        = string
  default     = null
}

variable "instance_type" {
  description = "Instance Type"
  type        = string
  default     = "t2.micro"
}

variable "instance_name" {
  description = "Instance Name"
  type        = string
}

variable "subnet_id" {
  type        = string
  description = "SUBNET ID."
  sensitive   = false
}

variable "use_security_groups" {
  type        = list(string)
  description = "List of security groups to associate with the instance"
  default     = []
}

variable "has_iam_role" {
  type        = bool
  description = "İf has role use iam_role_profile"
  default     = false
}
variable "instance_profile" {
  type        = string
  description = "The IAM instance profile to attach to the EC2 instance"
  default     = null
}
variable "user_data_script" {
  type        = string
  description = "Control for .txt file creating, pushing and publishing "
  default     = null
}

variable "spot_price" {
  description = "Spot instance maximum price (leave empty for On-Demand)"
  type        = string
  default     = ""
}

variable "availability_zone" {
  description = "AZ for Intances"
  type        = string
  default     = null
}

variable "placementgroup_name" {
  description = "placement group name"
  type        = string
  default     = null
}

variable "hibernation" {
  description = "Hibernation for EC2"
  type        = bool
  default     = false
}

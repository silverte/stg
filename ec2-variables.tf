# EC2 Root Volume size
variable "ec2_root_volume_size" {
  description = "EC2 Root Volume size"
  type        = number
  default     = 30
}

# EC2 AMI ID
variable "ec2_ami_id" {
  description = "EC2 AMI id"
  type        = string
  default     = ""
}


# Whether to create an workbench (True or False)
variable "create_ec2_workbench" {
  description = "Whether to create an EC2 IMDG"
  type        = bool
  default     = false
}

# EC2 Instance Type
variable "ec2_workbench_instance_type" {
  description = "EC2 Instance Type"
  type        = string
  default     = "t4g.medium"
}

# EC2 EBS Volume size
variable "ec2_workbench_ebs_volume_size" {
  description = "EC2 EBS Volume size"
  type        = number
  default     = 100
}

# EC2 Private IP address
variable "ec2_workbench_private_ip" {
  description = "EC2 Private IP address"
  type        = string
  default     = ""
}

# Whether to create an batch worker (True or False)
variable "create_ec2_batch_worker" {
  description = "Whether to create an Batch worker"
  type        = bool
  default     = false
}

# EC2 Instance Type
variable "ec2_batch_worker_instance_type" {
  description = "EC2 Instance Type"
  type        = string
  default     = "t4g.medium"
}

# EC2 EBS Volume size
variable "ec2_batch_worker_ebs_volume_size" {
  description = "EC2 EBS Volume size"
  type        = number
  default     = 100
}

# EC2 Private IP address
variable "ec2_batch_worker_private_ip" {
  description = "EC2 Private IP address"
  type        = string
  default     = ""
}

# Whether to create an External Interface (True or False)
variable "create_ec2_external_interface" {
  description = "Whether to create an External Interface"
  type        = bool
  default     = false
}

# EC2 Instance Type
variable "ec2_external_interface_instance_type" {
  description = "EC2 Instance Type"
  type        = string
  default     = "t4g.medium"
}

# EC2 EBS Volume size
variable "ec2_external_interface_ebs_volume_size" {
  description = "EC2 EBS Volume size"
  type        = number
  default     = 100
}

# EC2 Private IP address
variable "ec2_external_interface_private_ip" {
  description = "EC2 Private IP address"
  type        = string
  default     = ""
}

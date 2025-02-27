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

#######################################################
# Workbench
#######################################################
# Whether to create an workbench (True or False)
variable "create_ec2_workbench" {
  description = "Whether to create an Workbench"
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

#######################################################
# Batch Worker
#######################################################
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

#######################################################
# External Interface
#######################################################
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

#######################################################
# Armedis(OSS Redis)
#######################################################
# Whether to create an External Interface (True or False)
variable "create_ec2_armedis" {
  description = "Whether to create an Armedis"
  type        = bool
  default     = false
}

# EC2 Instance Type
variable "ec2_armedis_instance_type" {
  description = "EC2 Instance Type"
  type        = string
  default     = "t4g.medium"
}

# EC2 EBS Volume size
variable "ec2_armedis_ebs_volume_size" {
  description = "EC2 EBS Volume size"
  type        = number
  default     = 100
}

# EC2 Private IP address
variable "ec2_armedis_private_ip" {
  description = "EC2 Private IP address"
  type        = string
  default     = ""
}

#######################################################
# Ezwel Market
#######################################################
# Whether to create an External Interface (True or False)
variable "create_ec2_market" {
  description = "Whether to create an Armedis"
  type        = bool
  default     = false
}

# EC2 Instance Type
variable "ec2_market_instance_type" {
  description = "EC2 Instance Type"
  type        = string
  default     = "t4g.medium"
}

# EC2 EBS Volume size
variable "ec2_market_ebs_volume_size" {
  description = "EC2 EBS Volume size"
  type        = number
  default     = 100
}

# EC2 Private IP address
variable "ec2_market_private_ip" {
  description = "EC2 Private IP address"
  type        = string
  default     = ""
}

#######################################################
# Ezwel Pay CMS
#######################################################
# Whether to create an External Interface (True or False)
variable "create_ec2_pay_cms" {
  description = "Whether to create an Armedis"
  type        = bool
  default     = false
}

# EC2 Instance Type
variable "ec2_pay_cms_instance_type" {
  description = "EC2 Instance Type"
  type        = string
  default     = "t4g.medium"
}

# EC2 EBS Volume size
variable "ec2_pay_cms_ebs_volume_size" {
  description = "EC2 EBS Volume size"
  type        = number
  default     = 100
}

# EC2 Private IP address
variable "ec2_pay_cms_private_ip" {
  description = "EC2 Private IP address"
  type        = string
  default     = ""
}

#######################################################
# Ezwel Pay WAS
#######################################################
# Whether to create an External Interface (True or False)
variable "create_ec2_pay_was" {
  description = "Whether to create an Armedis"
  type        = bool
  default     = false
}

# EC2 Instance Type
variable "ec2_pay_was_instance_type" {
  description = "EC2 Instance Type"
  type        = string
  default     = "t4g.medium"
}

# EC2 EBS Volume size
variable "ec2_pay_was_ebs_volume_size" {
  description = "EC2 EBS Volume size"
  type        = number
  default     = 100
}

# EC2 Private IP address
variable "ec2_pay_was_private_ip" {
  description = "EC2 Private IP address"
  type        = string
  default     = ""
}

#######################################################
# Ezwel checkin adm
#######################################################
# Whether to create an External Interface (True or False)
variable "create_ec2_checkin_adm" {
  description = "Whether to create an Armedis"
  type        = bool
  default     = false
}

# EC2 Instance Type
variable "ec2_checkin_adm_instance_type" {
  description = "EC2 Instance Type"
  type        = string
  default     = "t4g.medium"
}

# EC2 EBS Volume size
variable "ec2_checkin_adm_ebs_volume_size" {
  description = "EC2 EBS Volume size"
  type        = number
  default     = 100
}

# EC2 Private IP address
variable "ec2_checkin_adm_private_ip" {
  description = "EC2 Private IP address"
  type        = string
  default     = ""
}

#######################################################
# Ezwel checkin api
#######################################################
# Whether to create an External Interface (True or False)
variable "create_ec2_checkin_api" {
  description = "Whether to create an Armedis"
  type        = bool
  default     = false
}

# EC2 Instance Type
variable "ec2_checkin_api_instance_type" {
  description = "EC2 Instance Type"
  type        = string
  default     = "t4g.medium"
}

# EC2 EBS Volume size
variable "ec2_checkin_api_ebs_volume_size" {
  description = "EC2 EBS Volume size"
  type        = number
  default     = 100
}

# EC2 Private IP address
variable "ec2_checkin_api_private_ip" {
  description = "EC2 Private IP address"
  type        = string
  default     = ""
}

#######################################################
# Healthcare
#######################################################
# Whether to create an External Interface (True or False)
variable "create_ec2_healthcare" {
  description = "Whether to create an Armedis"
  type        = bool
  default     = false
}

# EC2 Instance Type
variable "ec2_healthcare_instance_type" {
  description = "EC2 Instance Type"
  type        = string
  default     = "t4g.medium"
}

# EC2 EBS Volume size
variable "ec2_healthcare_ebs_volume_size" {
  description = "EC2 EBS Volume size"
  type        = number
  default     = 100
}

# EC2 Private IP address
variable "ec2_healthcare_private_ip" {
  description = "EC2 Private IP address"
  type        = string
  default     = ""
}

#######################################################
# Homepage
#######################################################
# Whether to create an External Interface (True or False)
variable "create_ec2_homepage" {
  description = "Whether to create an Armedis"
  type        = bool
  default     = false
}

# EC2 Instance Type
variable "ec2_homepage_instance_type" {
  description = "EC2 Instance Type"
  type        = string
  default     = "t4g.medium"
}

# EC2 EBS Volume size
variable "ec2_homepage_ebs_volume_size" {
  description = "EC2 EBS Volume size"
  type        = number
  default     = 100
}

# EC2 Private IP address
variable "ec2_homepage_private_ip" {
  description = "EC2 Private IP address"
  type        = string
  default     = ""
}

#######################################################
# EC2 admin
#######################################################
# Whether to create an External Interface (True or False)
variable "create_ec2_admin" {
  description = "Whether to create an Admin"
  type        = bool
  default     = false
}

# EC2 Instance Type
variable "ec2_admin_instance_type" {
  description = "EC2 Instance Type"
  type        = string
  default     = "t4g.medium"
}

# EC2 EBS Volume size
variable "ec2_admin_ebs_volume_size" {
  description = "EC2 EBS Volume size"
  type        = number
  default     = 100
}

# EC2 Private IP address
variable "ec2_admin_private_ip" {
  description = "EC2 Private IP address"
  type        = string
  default     = ""
}

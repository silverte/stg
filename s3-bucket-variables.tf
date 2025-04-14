# Whether to create an S3 Bucket (True or False)
variable "create_s3_bucket" {
  description = "Whether to create an S3 Bucket App"
  type        = bool
  default     = false
}

# S3 Bucket names
variable "s3_bucket_names" {
  description = "List of S3 Bucket names"
  type        = list(string)
  default     = []
}

# Whether to create an S3 Bucket for App logs (True or False)
variable "create_s3_bucket_app_logs" {
  description = "Whether to create an S3 Bucket App"
  type        = bool
  default     = false
}

# S3 Bucket names
variable "s3_bucket_name_app_logs" {
  description = "S3 Bucket name for App logs"
  type        = string
  default     = ""
}

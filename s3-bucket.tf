################################################################################
# S3 Module
# reference: https://github.com/terraform-aws-modules/terraform-aws-s3-bucket
#            https://github.com/terraform-aws-modules/terraform-aws-s3-object
################################################################################
module "s3_bucket_cm_contents" {
  source        = "terraform-aws-modules/s3-bucket/aws"
  create_bucket = var.create_s3_bucket
  for_each      = toset(var.s3_bucket_names)

  bucket        = "s3-${var.service}-${var.environment}-${each.key}"
  force_destroy = true

  tags = merge(
    local.tags,
    {
      "Name" = "s3-${var.service}-${var.environment}-${each.key}"
    }
  )
}

module "s3_bucket_app_logs" {
  source        = "terraform-aws-modules/s3-bucket/aws"
  version       = "~> 4.0"
  create_bucket = var.create_s3_bucket_app_logs

  bucket        = "s3-${var.service}-${var.environment}-${var.s3_bucket_name_app_logs}"
  force_destroy = false

  # Object Lock 활성화
  object_lock_enabled = true

  # 기본 Object Lock 설정 (Governance Mode, 5년)
  object_lock_configuration = {
    object_lock_enabled = "Enabled"
    rule = {
      default_retention = {
        mode = "GOVERNANCE"
        days = 1825
      }
    }
  }

  # Lifecycle 규칙
  lifecycle_rule = [
    {
      id      = "StandardToDeepArchiveThenDelete"
      enabled = true

      transition = [{
        days          = 365
        storage_class = "DEEP_ARCHIVE"
      }]

      expiration = {
        days = 1825
      }
    }
  ]
}

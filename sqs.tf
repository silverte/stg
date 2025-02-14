################################################################################
# SQS Module
# reference: https://github.com/terraform-aws-modules/terraform-aws-sqs
################################################################################
module "sqs_app" {
  source = "terraform-aws-modules/sqs/aws"
  create = var.create_sqs

  name       = "sqs-${var.service}-${var.environment}-app"
  fifo_queue = true

  tags = merge(
    local.tags,
    {
      "Name" = "sqs-${var.service}-${var.environment}-app"
    }
  )
}

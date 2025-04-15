################################################################################
# ECR Repository
# reference: https://github.com/terraform-aws-modules/terraform-aws-ecr
################################################################################
module "ecr-app" {
  source   = "terraform-aws-modules/ecr/aws"
  create   = var.create_ecr
  for_each = toset(var.ecr_names)

  repository_name                 = each.key
  repository_image_tag_mutability = "MUTABLE"

  # repository_read_write_access_arns = [data.aws_caller_identity.current.arn]
  create_lifecycle_policy = true
  repository_lifecycle_policy = jsonencode({
    "rules" : [
      {
        "rulePriority" : 2,
        "description" : "Keep at least 10 images for any tag",
        "selection" : {
          "tagStatus" : "any",
          "countType" : "imageCountMoreThan",
          "countNumber" : 10
        },
        "action" : {
          "type" : "expire"
        }
      },
      {
        "rulePriority" : 1,
        "description" : "Keep images with prefix tag pattern from the last 10 days",
        "selection" : {
          "tagStatus" : "tagged",
          "tagPrefixList" : ["dev", "stg", "prd"],
          "countType" : "sinceImagePushed",
          "countUnit" : "days",
          "countNumber" : 10
        },
        "action" : {
          "type" : "expire"
        }
      }
    ]
    }
  )

  create_repository_policy = false
  repository_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AmdpEcrPushFromSharedVpc",
        Effect = "Allow",
        Principal = {
          "AWS" : "arn:aws:iam::${var.accounts["shared"]}:role/role-esp-shared-amdp-tekton"
        },
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:CompleteLayerUpload",
          "ecr:GetDownloadUrlForLayer",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart"
        ]
      }
    ]
  })

  repository_force_delete = false

  #   # Registry Scanning Configuration
  #   manage_registry_scanning_configuration = true
  #   registry_scan_type                     = "ENHANCED"
  #   registry_scan_rules = [
  #     {
  #       scan_frequency = "SCAN_ON_PUSH"
  #       filter = [
  #         {
  #           filter      = "example1"
  #           filter_type = "WILDCARD"
  #         },
  #         { filter      = "example2"
  #           filter_type = "WILDCARD"
  #         }
  #       ]
  #       }, {
  #       scan_frequency = "CONTINUOUS_SCAN"
  #       filter = [
  #         {
  #           filter      = "example"
  #           filter_type = "WILDCARD"
  #         }
  #       ]
  #     }
  #   ]

  tags = merge(
    local.tags,
    {
      "Name" = "ecr-${var.service}-${var.environment}-${each.key}"
    }
  )
}

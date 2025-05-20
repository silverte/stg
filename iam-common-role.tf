##########################################################################
# IAM Module
# reference: https://github.com/terraform-aws-modules/terraform-aws-iam
##########################################################################
module "iam_account" {
  source                         = "terraform-aws-modules/iam/aws//modules/iam-account"
  create_account_password_policy = var.create_account_password_policy

  account_alias = var.account_alias

  max_password_age             = 90
  minimum_password_length      = 8
  password_reuse_prevention    = 3
  require_lowercase_characters = true
  require_uppercase_characters = true
  require_symbols              = true
  require_numbers              = true
}

#################################################################################
# IAM assumable role for admin
#################################################################################
module "iam_assumable_role_admin" {
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  count  = var.create_iam_assumeable_role ? 1 : 0

  # https://aws.amazon.com/blogs/security/announcing-an-update-to-iam-role-trust-policy-behavior/
  allow_self_assume_role = true

  trusted_role_arns = [
    "arn:aws:iam::${var.accounts["mgmt"]}:root"
  ]

  # trusted_role_services = [
  #   "codedeploy.amazonaws.com"
  # ]

  create_role             = true
  create_instance_profile = false

  role_name           = "role-${var.service}-${var.environment}-admin"
  role_requires_mfa   = true
  attach_admin_policy = true
  custom_role_policy_arns = [
    # module.iam_policy_restrict_ip.arn,
    # module.iam_policy_restrict_region.arn,
  ]

  tags = merge(
    local.tags,
    {
      Name = "role-${var.service}-${var.environment}-admin"
    },
  )
}

#################################################################################
# IAM assumable role for powerUser
#################################################################################
module "iam_assumable_role_poweruser" {
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  count  = var.create_iam_assumeable_role ? 1 : 0

  # https://aws.amazon.com/blogs/security/announcing-an-update-to-iam-role-trust-policy-behavior/
  allow_self_assume_role = true

  trusted_role_arns = [
    "arn:aws:iam::${var.accounts["mgmt"]}:root"
  ]

  create_role             = true
  create_instance_profile = false

  role_name               = "role-${var.service}-${var.environment}-powerUser"
  role_requires_mfa       = true
  attach_poweruser_policy = true
  custom_role_policy_arns = [
    module.iam_policy_restrict_ip.arn,
    module.iam_policy_restrict_region.arn,
  ]

  tags = merge(
    local.tags,
    {
      Name = "role-${var.service}-${var.environment}-powerUser"
    },
  )
}

#################################################################################
# IAM assumable role for databaseAdmin
#################################################################################
module "iam_assumable_role_databaseadmin" {
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  count  = var.create_iam_assumeable_role ? 1 : 0

  # https://aws.amazon.com/blogs/security/announcing-an-update-to-iam-role-trust-policy-behavior/
  allow_self_assume_role = true

  trusted_role_arns = [
    "arn:aws:iam::${var.accounts["mgmt"]}:root"
  ]

  create_role             = true
  create_instance_profile = false

  role_name         = "role-${var.service}-${var.environment}-databaseAdmin"
  role_requires_mfa = true
  custom_role_policy_arns = [
    "arn:aws:iam::aws:policy/job-function/DatabaseAdministrator",
    module.iam_policy_restrict_ip.arn,
    module.iam_policy_restrict_region.arn,
  ]

  tags = merge(
    local.tags,
    {
      Name = "role-${var.service}-${var.environment}-databaseAdmin"
    },
  )
}

#################################################################################
# IAM assumable role for systemAdmin
#################################################################################
module "iam_assumable_role_systemadmin" {
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  count  = var.create_iam_assumeable_role ? 1 : 0

  # https://aws.amazon.com/blogs/security/announcing-an-update-to-iam-role-trust-policy-behavior/
  allow_self_assume_role = true

  trusted_role_arns = [
    "arn:aws:iam::${var.accounts["mgmt"]}:root"
  ]

  create_role             = true
  create_instance_profile = false

  role_name         = "role-${var.service}-${var.environment}-systemAdmin"
  role_requires_mfa = true
  custom_role_policy_arns = [
    "arn:aws:iam::aws:policy/job-function/SystemAdministrator",
    module.iam_policy_restrict_ip.arn,
    module.iam_policy_restrict_region.arn,
  ]

  tags = merge(
    local.tags,
    {
      Name = "role-${var.service}-${var.environment}-systemAdmin"
    },
  )
}

#################################################################################
# IAM assumable role for networkAdmin
#################################################################################
module "iam_assumable_role_networkadmin" {
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  count  = var.create_iam_assumeable_role ? 1 : 0

  # https://aws.amazon.com/blogs/security/announcing-an-update-to-iam-role-trust-policy-behavior/
  allow_self_assume_role = true

  trusted_role_arns = [
    "arn:aws:iam::${var.accounts["mgmt"]}:root"
  ]

  create_role             = true
  create_instance_profile = false

  role_name         = "role-${var.service}-${var.environment}-networkAdmin"
  role_requires_mfa = true
  custom_role_policy_arns = [
    "arn:aws:iam::aws:policy/job-function/NetworkAdministrator",
    module.iam_policy_restrict_ip.arn,
    module.iam_policy_restrict_region.arn,
  ]

  tags = merge(
    local.tags,
    {
      Name = "role-${var.service}-${var.environment}-networkAdmin"
    },
  )
}

#################################################################################
# IAM assumable role for viewOnly
#################################################################################
module "iam_assumable_role_viewonly" {
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  count  = var.create_iam_assumeable_role ? 1 : 0

  # https://aws.amazon.com/blogs/security/announcing-an-update-to-iam-role-trust-policy-behavior/
  allow_self_assume_role = true

  trusted_role_arns = [
    "arn:aws:iam::${var.accounts["mgmt"]}:root"
  ]

  create_role             = true
  create_instance_profile = false

  role_name              = "role-${var.service}-${var.environment}-viewOnly"
  role_requires_mfa      = true
  attach_readonly_policy = true
  custom_role_policy_arns = [
    module.iam_policy_restrict_ip.arn,
    module.iam_policy_restrict_region.arn,
  ]

  tags = merge(
    local.tags,
    {
      Name = "role-${var.service}-${var.environment}-viewOnly"
    },
  )
}

#################################################################################
# IAM role for VM app
#################################################################################
resource "aws_iam_role" "vm_app" {
  name = "role-${var.service}-${var.environment}-vm-app-default"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
  tags = merge(
    local.tags,
    {
      Name = "role-${var.service}-${var.environment}-vm-app-default"
    },
  )
}

resource "aws_iam_role_policy_attachment" "attach_vm_default" {
  role       = aws_iam_role.vm_app.name
  policy_arn = module.iam_policy_vm_app.arn
}

resource "aws_iam_role_policy_attachment" "attach_vm_default_initial" {
  role       = aws_iam_role.vm_app.name
  policy_arn = module.iam_policy_vm_app_initial.arn
}


resource "aws_iam_role_policy_attachment" "attach_vm_ssm" {
  role       = aws_iam_role.vm_app.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "role-${var.service}-${var.environment}-vm-app-default"
  role = aws_iam_role.vm_app.name
}


#################################################################################
# IAM assumable role for EKS admin
#################################################################################
resource "aws_iam_role" "eks_admin" {
  name = "role-${var.service}-${var.environment}-eks-admin"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
  tags = merge(
    local.tags,
    {
      Name = "role-${var.service}-${var.environment}-eks-admin"
    },
  )
}

resource "aws_iam_role_policy_attachment" "attach_eksctl" {
  role       = aws_iam_role.eks_admin.name
  policy_arn = module.iam_policy_eksctl.arn
}

resource "aws_iam_role_policy_attachment" "attach_eks_node_viewer" {
  role       = aws_iam_role.eks_admin.name
  policy_arn = module.iam_policy_eks_node_viewer.arn
}

resource "aws_iam_role_policy_attachment" "attach_eks_admin" {
  role       = aws_iam_role.eks_admin.name
  policy_arn = module.iam_policy_eks_admin.arn
}


resource "aws_iam_role_policy_attachment" "attach_ecr_poweruser" {
  role       = aws_iam_role.eks_admin.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

resource "aws_iam_role_policy_attachment" "attach_cf_fullaccess" {
  role       = aws_iam_role.eks_admin.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCloudFormationFullAccess"
}

resource "aws_iam_instance_profile" "ec2_profile_eks-admin" {
  name = "role-${var.service}-${var.environment}-eks-admin"
  role = aws_iam_role.eks_admin.name
}

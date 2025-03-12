###################################################################################
# Security Group for RDS
###################################################################################
module "security_group_rds_maria" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"
  #create  = var.create_security_group
  create = false

  name            = "scg-${var.service}-${var.environment}-rds-${var.rds_mariadb_name}"
  use_name_prefix = false
  description     = "Security group for PostgreSQL"
  vpc_id          = data.aws_vpc.vpc.id

  tags = merge(
    local.tags,
    {
      "Name" = "scg-${var.service}-${var.environment}-rds-${var.rds_mariadb_name}"
    },
  )
}

module "security_group_oracle" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"
  #create  = var.create_security_group
  create = false

  name            = "scg-${var.service}-${var.environment}-rds-${var.rds_oracle_name}"
  use_name_prefix = false
  description     = "Security group for Oracle"
  vpc_id          = data.aws_vpc.vpc.id

  tags = merge(
    local.tags,
    {
      "Name" = "scg-${var.service}-${var.environment}-rds-${var.rds_oracle_name}"
    },
  )
}

module "security_group_aurora_postgresql" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"
  create  = var.create_security_group

  name            = "scg-${var.service}-${var.environment}-rds-aurora-postgresql"
  use_name_prefix = false
  description     = "Security group for Aurora PostgreSQL main"
  vpc_id          = data.aws_vpc.vpc.id

  tags = merge(
    local.tags,
    {
      "Name" = "scg-${var.service}-${var.environment}-rds-aurora-postgresql"
    },
  )
}

###################################################################################
# Security Group for ELB
###################################################################################
module "security_group_alb_container" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"
  create  = var.create_security_group

  name            = "scg-${var.service}-${var.environment}-alb-container"
  use_name_prefix = false
  description     = "Security group for EKS ALB ingress"
  vpc_id          = data.aws_vpc.vpc.id

  tags = merge(
    local.tags,
    {
      "Name" = "scg-${var.service}-${var.environment}-alb-container"
    },
  )
}

module "security_group_alb_vm" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"
  create  = var.create_security_group

  name            = "scg-${var.service}-${var.environment}-alb-vm"
  use_name_prefix = false
  description     = "Security group for VM ALB"
  vpc_id          = data.aws_vpc.vpc.id

  tags = merge(
    local.tags,
    {
      "Name" = "scg-${var.service}-${var.environment}-alb-vm"
    },
  )
}

module "security_group_nlb_container" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"
  create  = var.create_security_group

  name            = "scg-${var.service}-${var.environment}-nlb-container"
  use_name_prefix = false
  description     = "Security group for NLB container"
  vpc_id          = data.aws_vpc.vpc.id

  tags = merge(
    local.tags,
    {
      "Name" = "scg-${var.service}-${var.environment}-nlb-container"
    },
  )
}

module "security_group_nlb_vm" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"
  create  = var.create_security_group

  name            = "scg-${var.service}-${var.environment}-nlb-vm"
  use_name_prefix = false
  description     = "Security group for VM NLB"
  vpc_id          = data.aws_vpc.vpc.id

  tags = merge(
    local.tags,
    {
      "Name" = "scg-${var.service}-${var.environment}-nlb-vm"
    },
  )
}

###################################################################################
# Security Group for EC2
###################################################################################
module "security_group_ec2_workbench" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"
  create  = var.create_security_group

  name            = "scg-${var.service}-${var.environment}-ec2-workbench"
  use_name_prefix = false
  description     = "Security group for EC2 workbench"
  vpc_id          = data.aws_vpc.vpc.id

  tags = merge(
    local.tags,
    {
      "Name" = "scg-${var.service}-${var.environment}-ec2-workbench"
    },
  )
}

module "security_group_ec2_batch_worker" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"
  create  = var.create_security_group

  name            = "scg-${var.service}-${var.environment}-ec2-batch-worker"
  use_name_prefix = false
  description     = "Security group for EC2 batch_worker"
  vpc_id          = data.aws_vpc.vpc.id

  tags = merge(
    local.tags,
    {
      "Name" = "scg-${var.service}-${var.environment}-ec2-batch-worker"
    },
  )
}

module "security_group_ec2_armedis" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"
  create  = var.create_security_group

  name            = "scg-${var.service}-${var.environment}-ec2-armedis"
  use_name_prefix = false
  description     = "Security group for EC2 armedis"
  vpc_id          = data.aws_vpc.vpc.id

  tags = merge(
    local.tags,
    {
      "Name" = "scg-${var.service}-${var.environment}-ec2-armedis"
    },
  )
}

module "security_group_ec2_market" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"
  create  = var.create_security_group

  name            = "scg-${var.service}-${var.environment}-ec2-market"
  use_name_prefix = false
  description     = "Security group for EC2 ezwel market"
  vpc_id          = data.aws_vpc.vpc.id

  tags = merge(
    local.tags,
    {
      "Name" = "scg-${var.service}-${var.environment}-ec2-market"
    },
  )
}

module "security_group_ec2_pay_cms" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"
  create  = var.create_security_group

  name            = "scg-${var.service}-${var.environment}-ec2-pay-cms"
  use_name_prefix = false
  description     = "Security group for EC2 ezwel pay cms"
  vpc_id          = data.aws_vpc.vpc.id

  tags = merge(
    local.tags,
    {
      "Name" = "scg-${var.service}-${var.environment}-ec2-pay-cms"
    },
  )
}

module "security_group_ec2_pay_was" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"
  create  = var.create_security_group

  name            = "scg-${var.service}-${var.environment}-ec2-pay-was"
  use_name_prefix = false
  description     = "Security group for EC2 ezwel pay was"
  vpc_id          = data.aws_vpc.vpc.id

  tags = merge(
    local.tags,
    {
      "Name" = "scg-${var.service}-${var.environment}-ec2-pay-was"
    },
  )
}

module "security_group_ec2_checkin_adm" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"
  create  = var.create_security_group

  name            = "scg-${var.service}-${var.environment}-ec2-checkin-adm"
  use_name_prefix = false
  description     = "Security group for EC2 ez checkin admin"
  vpc_id          = data.aws_vpc.vpc.id

  tags = merge(
    local.tags,
    {
      "Name" = "scg-${var.service}-${var.environment}-ec2-checkin-adm"
    },
  )
}

module "security_group_ec2_checkin_api" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"
  create  = var.create_security_group

  name            = "scg-${var.service}-${var.environment}-ec2-checkin-api"
  use_name_prefix = false
  description     = "Security group for EC2 ez checkin api"
  vpc_id          = data.aws_vpc.vpc.id

  tags = merge(
    local.tags,
    {
      "Name" = "scg-${var.service}-${var.environment}-ec2-checkin-api"
    },
  )
}

module "security_group_ec2_healthcare" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"
  create  = var.create_security_group

  name            = "scg-${var.service}-${var.environment}-ec2-healthcare"
  use_name_prefix = false
  description     = "Security group for EC2 healthcare..."
  vpc_id          = data.aws_vpc.vpc.id

  tags = merge(
    local.tags,
    {
      "Name" = "scg-${var.service}-${var.environment}-ec2-healthcare"
    },
  )
}

module "security_group_ec2_homepage" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"
  create  = var.create_security_group

  name            = "scg-${var.service}-${var.environment}-ec2-homepage"
  use_name_prefix = false
  description     = "Security group for EC2 hompage..."
  vpc_id          = data.aws_vpc.vpc.id

  tags = merge(
    local.tags,
    {
      "Name" = "scg-${var.service}-${var.environment}-ec2-homepage"
    },
  )
}

module "security_group_ec2_external_interface" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"
  create  = var.create_security_group

  name            = "scg-${var.service}-${var.environment}-ec2-external-interface"
  use_name_prefix = false
  description     = "Security group for External Interface"
  vpc_id          = data.aws_vpc.vpc.id

  tags = merge(
    local.tags,
    {
      "Name" = "scg-${var.service}-${var.environment}-ec2-external-interface"
    },
  )
}

module "security_group_ec2_admin" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"
  create  = var.create_security_group

  name            = "scg-${var.service}-${var.environment}-ec2-admin"
  use_name_prefix = false
  description     = "Security group for EC2 admin"
  vpc_id          = data.aws_vpc.vpc.id

  tags = merge(
    local.tags,
    {
      "Name" = "scg-${var.service}-${var.environment}-ec2-admin"
    },
  )
}


###################################################################################
# Security Group for Elasticache
###################################################################################
module "security_group_elasticache_data" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"
  create  = var.create_security_group

  name            = "scg-${var.service}-${var.environment}-elasticache-data"
  use_name_prefix = false
  description     = "Security group for Elasticache data"
  vpc_id          = data.aws_vpc.vpc.id

  tags = merge(
    local.tags,
    {
      "Name" = "scg-${var.service}-${var.environment}-elasticache-data"
    },
  )
}

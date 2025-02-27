################################################################################
# EC2 Module
# reference: https://github.com/terraform-aws-modules/terraform-aws-ec2-instance
################################################################################

###################################################################################
# Workbench
###################################################################################
module "ec2_workbench" {
  source = "terraform-aws-modules/ec2-instance/aws"
  create = var.create_ec2_workbench

  name = "ec2-${var.service}-${var.environment}-workbench"

  ami                         = var.ec2_ami_id
  instance_type               = var.ec2_workbench_instance_type
  availability_zone           = element(local.azs, 0)
  subnet_id                   = data.aws_subnets.app_vm_a.ids[0]
  vpc_security_group_ids      = [module.security_group_ec2_workbench.security_group_id]
  associate_public_ip_address = false
  disable_api_stop            = false
  disable_api_termination     = true
  # https://docs.aws.amazon.com/ko_kr/AWSEC2/latest/UserGuide/hibernating-prerequisites.html#hibernation-prereqs-supported-amis
  hibernation                 = false
  user_data_base64            = base64encode(file("./user_data.sh"))
  user_data_replace_on_change = true
  private_ip                  = var.ec2_workbench_private_ip

  metadata_options = {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  enable_volume_tags = false
  root_block_device = [
    {
      encrypted   = true
      kms_key_id  = data.aws_kms_key.ebs.arn
      volume_type = "gp3"
      volume_size = var.ec2_root_volume_size
      tags = merge(
        local.tags,
        {
          "Name" = "ebs-${var.service}-${var.environment}-workbench-root"
        },
      )
    },
  ]

  ebs_block_device = [
    {
      device_name = "/dev/sdf"
      volume_type = "gp3"
      volume_size = var.ec2_workbench_ebs_volume_size
      encrypted   = true
      kms_key_id  = data.aws_kms_key.ebs.arn
      tags = merge(
        local.tags,
        {
          "Name" = "ebs-${var.service}-${var.environment}-workbench-data01"
        },
      )
    }
  ]

  tags = merge(
    local.tags,
    {
      "Name" = "ec2-${var.service}-${var.environment}-workbench"
    },
  )
}

###################################################################################
# Batch Worker
###################################################################################
module "ec2_batch_worker" {
  source = "terraform-aws-modules/ec2-instance/aws"
  create = var.create_ec2_batch_worker

  name = "ec2-${var.service}-${var.environment}-workbench"

  ami                         = var.ec2_ami_id
  instance_type               = var.ec2_batch_worker_instance_type
  availability_zone           = element(local.azs, 0)
  subnet_id                   = data.aws_subnets.app_vm_a.ids[0]
  vpc_security_group_ids      = [module.security_group_ec2_batch_worker.security_group_id]
  associate_public_ip_address = false
  disable_api_stop            = false
  disable_api_termination     = true
  # https://docs.aws.amazon.com/ko_kr/AWSEC2/latest/UserGuide/hibernating-prerequisites.html#hibernation-prereqs-supported-amis
  hibernation                 = false
  user_data_base64            = base64encode(file("./user_data.sh"))
  user_data_replace_on_change = true
  private_ip                  = var.ec2_batch_worker_private_ip

  metadata_options = {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  enable_volume_tags = false
  root_block_device = [
    {
      encrypted   = true
      kms_key_id  = data.aws_kms_key.ebs.arn
      volume_type = "gp3"
      volume_size = var.ec2_root_volume_size
      tags = merge(
        local.tags,
        {
          "Name" = "ebs-${var.service}-${var.environment}-batch-worker-root"
        },
      )
    },
  ]

  ebs_block_device = [
    {
      device_name = "/dev/sdf"
      volume_type = "gp3"
      volume_size = var.ec2_workbench_ebs_volume_size
      encrypted   = true
      kms_key_id  = data.aws_kms_key.ebs.arn
      tags = merge(
        local.tags,
        {
          "Name" = "ebs-${var.service}-${var.environment}-batch-worker-data01"
        },
      )
    }
  ]

  tags = merge(
    local.tags,
    {
      "Name" = "ec2-${var.service}-${var.environment}-batch-worker"
    },
  )
}

###################################################################################
# External Interface
###################################################################################
module "ec2_external_interface" {
  source = "terraform-aws-modules/ec2-instance/aws"
  create = var.create_ec2_batch_worker

  name = "ec2-${var.service}-${var.environment}-external-interface"

  ami                         = var.ec2_ami_id
  instance_type               = var.ec2_external_interface_instance_type
  availability_zone           = element(local.azs, 0)
  subnet_id                   = data.aws_subnets.app_vm_a.ids[0]
  vpc_security_group_ids      = [module.security_group_ec2_batch_worker.security_group_id]
  associate_public_ip_address = false
  disable_api_stop            = false
  disable_api_termination     = true
  # https://docs.aws.amazon.com/ko_kr/AWSEC2/latest/UserGuide/hibernating-prerequisites.html#hibernation-prereqs-supported-amis
  hibernation                 = false
  user_data_base64            = base64encode(file("./user_data.sh"))
  user_data_replace_on_change = true
  private_ip                  = var.ec2_external_interface_private_ip

  metadata_options = {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  enable_volume_tags = false
  root_block_device = [
    {
      encrypted   = true
      kms_key_id  = data.aws_kms_key.ebs.arn
      volume_type = "gp3"
      volume_size = var.ec2_root_volume_size
      tags = merge(
        local.tags,
        {
          "Name" = "ebs-${var.service}-${var.environment}-external-interface-root"
        },
      )
    },
  ]

  ebs_block_device = [
    {
      device_name = "/dev/sdf"
      volume_type = "gp3"
      volume_size = var.ec2_external_interface_ebs_volume_size
      encrypted   = true
      kms_key_id  = data.aws_kms_key.ebs.arn
      tags = merge(
        local.tags,
        {
          "Name" = "ebs-${var.service}-${var.environment}-external-interface-data01"
        },
      )
    }
  ]

  tags = merge(
    local.tags,
    {
      "Name" = "ec2-${var.service}-${var.environment}-external-interface"
    },
  )
}

###################################################################################
# Armedis(OSS Redis)
###################################################################################
module "ec2_armedis" {
  source = "terraform-aws-modules/ec2-instance/aws"
  create = var.create_ec2_armedis

  name = "ec2-${var.service}-${var.environment}-armedis"

  ami                         = var.ec2_ami_id
  instance_type               = var.ec2_armedis_instance_type
  availability_zone           = element(local.azs, 0)
  subnet_id                   = data.aws_subnets.app_vm_a.ids[0]
  vpc_security_group_ids      = [module.security_group_ec2_armedis.security_group_id]
  associate_public_ip_address = false
  disable_api_stop            = false
  disable_api_termination     = true
  # https://docs.aws.amazon.com/ko_kr/AWSEC2/latest/UserGuide/hibernating-prerequisites.html#hibernation-prereqs-supported-amis
  hibernation                 = false
  user_data_base64            = base64encode(file("./user_data.sh"))
  user_data_replace_on_change = true
  private_ip                  = var.ec2_armedis_private_ip

  metadata_options = {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  enable_volume_tags = false
  root_block_device = [
    {
      encrypted   = true
      kms_key_id  = data.aws_kms_key.ebs.arn
      volume_type = "gp3"
      volume_size = var.ec2_root_volume_size
      tags = merge(
        local.tags,
        {
          "Name" = "ebs-${var.service}-${var.environment}-armedis-root"
        },
      )
    },
  ]

  ebs_block_device = [
    {
      device_name = "/dev/sdf"
      volume_type = "gp3"
      volume_size = var.ec2_armedis_ebs_volume_size
      encrypted   = true
      kms_key_id  = data.aws_kms_key.ebs.arn
      tags = merge(
        local.tags,
        {
          "Name" = "ebs-${var.service}-${var.environment}-armedis-data01"
        },
      )
    }
  ]

  tags = merge(
    local.tags,
    {
      "Name" = "ec2-${var.service}-${var.environment}-armedis"
    },
  )
}

###################################################################################
# Market
###################################################################################
module "ec2_market" {
  source = "terraform-aws-modules/ec2-instance/aws"
  create = var.create_ec2_market

  name = "ec2-${var.service}-${var.environment}-market"

  ami                         = var.ec2_ami_id
  instance_type               = var.ec2_market_instance_type
  availability_zone           = element(local.azs, 0)
  subnet_id                   = data.aws_subnets.app_vm_a.ids[0]
  vpc_security_group_ids      = [module.security_group_ec2_market.security_group_id]
  associate_public_ip_address = false
  disable_api_stop            = false
  disable_api_termination     = true
  # https://docs.aws.amazon.com/ko_kr/AWSEC2/latest/UserGuide/hibernating-prerequisites.html#hibernation-prereqs-supported-amis
  hibernation                 = false
  user_data_base64            = base64encode(file("./user_data.sh"))
  user_data_replace_on_change = true
  private_ip                  = var.ec2_market_private_ip

  metadata_options = {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  enable_volume_tags = false
  root_block_device = [
    {
      encrypted   = true
      kms_key_id  = data.aws_kms_key.ebs.arn
      volume_type = "gp3"
      volume_size = var.ec2_root_volume_size
      tags = merge(
        local.tags,
        {
          "Name" = "ebs-${var.service}-${var.environment}-market-root"
        },
      )
    },
  ]

  ebs_block_device = [
    {
      device_name = "/dev/sdf"
      volume_type = "gp3"
      volume_size = var.ec2_market_ebs_volume_size
      encrypted   = true
      kms_key_id  = data.aws_kms_key.ebs.arn
      tags = merge(
        local.tags,
        {
          "Name" = "ebs-${var.service}-${var.environment}-market-data01"
        },
      )
    }
  ]

  tags = merge(
    local.tags,
    {
      "Name" = "ec2-${var.service}-${var.environment}-market"
    },
  )
}

###################################################################################
# Pay CMS
###################################################################################
module "ec2_pay_cms" {
  source = "terraform-aws-modules/ec2-instance/aws"
  create = var.create_ec2_pay_cms

  name = "ec2-${var.service}-${var.environment}-pay-cms"

  ami                         = var.ec2_ami_id
  instance_type               = var.ec2_pay_cms_instance_type
  availability_zone           = element(local.azs, 0)
  subnet_id                   = data.aws_subnets.app_vm_a.ids[0]
  vpc_security_group_ids      = [module.security_group_ec2_pay_cms.security_group_id]
  associate_public_ip_address = false
  disable_api_stop            = false
  disable_api_termination     = true
  # https://docs.aws.amazon.com/ko_kr/AWSEC2/latest/UserGuide/hibernating-prerequisites.html#hibernation-prereqs-supported-amis
  hibernation                 = false
  user_data_base64            = base64encode(file("./user_data.sh"))
  user_data_replace_on_change = true
  private_ip                  = var.ec2_pay_cms_private_ip

  metadata_options = {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  enable_volume_tags = false
  root_block_device = [
    {
      encrypted   = true
      kms_key_id  = data.aws_kms_key.ebs.arn
      volume_type = "gp3"
      volume_size = var.ec2_root_volume_size
      tags = merge(
        local.tags,
        {
          "Name" = "ebs-${var.service}-${var.environment}-pay-cms-root"
        },
      )
    },
  ]

  ebs_block_device = [
    {
      device_name = "/dev/sdf"
      volume_type = "gp3"
      volume_size = var.ec2_pay_cms_ebs_volume_size
      encrypted   = true
      kms_key_id  = data.aws_kms_key.ebs.arn
      tags = merge(
        local.tags,
        {
          "Name" = "ebs-${var.service}-${var.environment}-pay-cms-data01"
        },
      )
    }
  ]

  tags = merge(
    local.tags,
    {
      "Name" = "ec2-${var.service}-${var.environment}-pay-cms"
    },
  )
}

###################################################################################
# Pay WAS
###################################################################################
module "ec2_pay_was" {
  source = "terraform-aws-modules/ec2-instance/aws"
  create = var.create_ec2_pay_was

  name = "ec2-${var.service}-${var.environment}-pay-was"

  ami                         = var.ec2_ami_id
  instance_type               = var.ec2_pay_was_instance_type
  availability_zone           = element(local.azs, 0)
  subnet_id                   = data.aws_subnets.app_vm_a.ids[0]
  vpc_security_group_ids      = [module.security_group_ec2_pay_was.security_group_id]
  associate_public_ip_address = false
  disable_api_stop            = false
  disable_api_termination     = true
  # https://docs.aws.amazon.com/ko_kr/AWSEC2/latest/UserGuide/hibernating-prerequisites.html#hibernation-prereqs-supported-amis
  hibernation                 = false
  user_data_base64            = base64encode(file("./user_data.sh"))
  user_data_replace_on_change = true
  private_ip                  = var.ec2_pay_was_private_ip

  metadata_options = {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  enable_volume_tags = false
  root_block_device = [
    {
      encrypted   = true
      kms_key_id  = data.aws_kms_key.ebs.arn
      volume_type = "gp3"
      volume_size = var.ec2_root_volume_size
      tags = merge(
        local.tags,
        {
          "Name" = "ebs-${var.service}-${var.environment}-pay-was-root"
        },
      )
    },
  ]

  ebs_block_device = [
    {
      device_name = "/dev/sdf"
      volume_type = "gp3"
      volume_size = var.ec2_pay_was_ebs_volume_size
      encrypted   = true
      kms_key_id  = data.aws_kms_key.ebs.arn
      tags = merge(
        local.tags,
        {
          "Name" = "ebs-${var.service}-${var.environment}-pay-was-data01"
        },
      )
    }
  ]

  tags = merge(
    local.tags,
    {
      "Name" = "ec2-${var.service}-${var.environment}-pay-was"
    },
  )
}

###################################################################################
# Checkin adm
###################################################################################
module "ec2_checkin_adm" {
  source = "terraform-aws-modules/ec2-instance/aws"
  create = var.create_ec2_checkin_adm

  name = "ec2-${var.service}-${var.environment}-checkin-adm"

  ami                         = var.ec2_ami_id
  instance_type               = var.ec2_checkin_adm_instance_type
  availability_zone           = element(local.azs, 0)
  subnet_id                   = data.aws_subnets.app_vm_a.ids[0]
  vpc_security_group_ids      = [module.security_group_ec2_checkin_adm.security_group_id]
  associate_public_ip_address = false
  disable_api_stop            = false
  disable_api_termination     = true
  # https://docs.aws.amazon.com/ko_kr/AWSEC2/latest/UserGuide/hibernating-prerequisites.html#hibernation-prereqs-supported-amis
  hibernation                 = false
  user_data_base64            = base64encode(file("./user_data.sh"))
  user_data_replace_on_change = true
  private_ip                  = var.ec2_checkin_adm_private_ip

  metadata_options = {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  enable_volume_tags = false
  root_block_device = [
    {
      encrypted   = true
      kms_key_id  = data.aws_kms_key.ebs.arn
      volume_type = "gp3"
      volume_size = var.ec2_root_volume_size
      tags = merge(
        local.tags,
        {
          "Name" = "ebs-${var.service}-${var.environment}-checkin-adm-root"
        },
      )
    },
  ]

  ebs_block_device = [
    {
      device_name = "/dev/sdf"
      volume_type = "gp3"
      volume_size = var.ec2_checkin_adm_ebs_volume_size
      encrypted   = true
      kms_key_id  = data.aws_kms_key.ebs.arn
      tags = merge(
        local.tags,
        {
          "Name" = "ebs-${var.service}-${var.environment}-checkin-adm-data01"
        },
      )
    }
  ]

  tags = merge(
    local.tags,
    {
      "Name" = "ec2-${var.service}-${var.environment}-checkin-adm"
    },
  )
}

###################################################################################
# Checkin api
###################################################################################
module "ec2_checkin_api" {
  source = "terraform-aws-modules/ec2-instance/aws"
  create = var.create_ec2_checkin_api

  name = "ec2-${var.service}-${var.environment}-checkin-api"

  ami                         = var.ec2_ami_id
  instance_type               = var.ec2_checkin_api_instance_type
  availability_zone           = element(local.azs, 0)
  subnet_id                   = data.aws_subnets.app_vm_a.ids[0]
  vpc_security_group_ids      = [module.security_group_ec2_checkin_api.security_group_id]
  associate_public_ip_address = false
  disable_api_stop            = false
  disable_api_termination     = true
  # https://docs.aws.amazon.com/ko_kr/AWSEC2/latest/UserGuide/hibernating-prerequisites.html#hibernation-prereqs-supported-amis
  hibernation                 = false
  user_data_base64            = base64encode(file("./user_data.sh"))
  user_data_replace_on_change = true
  private_ip                  = var.ec2_checkin_api_private_ip

  metadata_options = {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  enable_volume_tags = false
  root_block_device = [
    {
      encrypted   = true
      kms_key_id  = data.aws_kms_key.ebs.arn
      volume_type = "gp3"
      volume_size = var.ec2_root_volume_size
      tags = merge(
        local.tags,
        {
          "Name" = "ebs-${var.service}-${var.environment}-checkin-api-root"
        },
      )
    },
  ]

  ebs_block_device = [
    {
      device_name = "/dev/sdf"
      volume_type = "gp3"
      volume_size = var.ec2_checkin_api_ebs_volume_size
      encrypted   = true
      kms_key_id  = data.aws_kms_key.ebs.arn
      tags = merge(
        local.tags,
        {
          "Name" = "ebs-${var.service}-${var.environment}-checkin-api-data01"
        },
      )
    }
  ]

  tags = merge(
    local.tags,
    {
      "Name" = "ec2-${var.service}-${var.environment}-checkin-api"
    },
  )
}

###################################################################################
# Healthcare
###################################################################################
module "ec2_healthcare" {
  source = "terraform-aws-modules/ec2-instance/aws"
  create = var.create_ec2_healthcare

  name = "ec2-${var.service}-${var.environment}-healthcare"

  ami                         = var.ec2_ami_id
  instance_type               = var.ec2_healthcare_instance_type
  availability_zone           = element(local.azs, 0)
  subnet_id                   = data.aws_subnets.app_vm_a.ids[0]
  vpc_security_group_ids      = [module.security_group_ec2_healthcare.security_group_id]
  associate_public_ip_address = false
  disable_api_stop            = false
  disable_api_termination     = true
  # https://docs.aws.amazon.com/ko_kr/AWSEC2/latest/UserGuide/hibernating-prerequisites.html#hibernation-prereqs-supported-amis
  hibernation                 = false
  user_data_base64            = base64encode(file("./user_data.sh"))
  user_data_replace_on_change = true
  private_ip                  = var.ec2_healthcare_private_ip

  metadata_options = {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  enable_volume_tags = false
  root_block_device = [
    {
      encrypted   = true
      kms_key_id  = data.aws_kms_key.ebs.arn
      volume_type = "gp3"
      volume_size = var.ec2_root_volume_size
      tags = merge(
        local.tags,
        {
          "Name" = "ebs-${var.service}-${var.environment}-healthcare-root"
        },
      )
    },
  ]

  ebs_block_device = [
    {
      device_name = "/dev/sdf"
      volume_type = "gp3"
      volume_size = var.ec2_healthcare_ebs_volume_size
      encrypted   = true
      kms_key_id  = data.aws_kms_key.ebs.arn
      tags = merge(
        local.tags,
        {
          "Name" = "ebs-${var.service}-${var.environment}-healthcare-data01"
        },
      )
    }
  ]

  tags = merge(
    local.tags,
    {
      "Name" = "ec2-${var.service}-${var.environment}-healthcare"
    },
  )
}

###################################################################################
# Hompage
###################################################################################
module "ec2_homepage" {
  source = "terraform-aws-modules/ec2-instance/aws"
  create = var.create_ec2_homepage

  name = "ec2-${var.service}-${var.environment}-homepage"

  ami                         = var.ec2_ami_id
  instance_type               = var.ec2_homepage_instance_type
  availability_zone           = element(local.azs, 0)
  subnet_id                   = data.aws_subnets.app_vm_a.ids[0]
  vpc_security_group_ids      = [module.security_group_ec2_homepage.security_group_id]
  associate_public_ip_address = false
  disable_api_stop            = false
  disable_api_termination     = true
  # https://docs.aws.amazon.com/ko_kr/AWSEC2/latest/UserGuide/hibernating-prerequisites.html#hibernation-prereqs-supported-amis
  hibernation                 = false
  user_data_base64            = base64encode(file("./user_data.sh"))
  user_data_replace_on_change = true
  private_ip                  = var.ec2_homepage_private_ip

  metadata_options = {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  enable_volume_tags = false
  root_block_device = [
    {
      encrypted   = true
      kms_key_id  = data.aws_kms_key.ebs.arn
      volume_type = "gp3"
      volume_size = var.ec2_root_volume_size
      tags = merge(
        local.tags,
        {
          "Name" = "ebs-${var.service}-${var.environment}-homepage-root"
        },
      )
    },
  ]

  ebs_block_device = [
    {
      device_name = "/dev/sdf"
      volume_type = "gp3"
      volume_size = var.ec2_homepage_ebs_volume_size
      encrypted   = true
      kms_key_id  = data.aws_kms_key.ebs.arn
      tags = merge(
        local.tags,
        {
          "Name" = "ebs-${var.service}-${var.environment}-homepage-data01"
        },
      )
    }
  ]

  tags = merge(
    local.tags,
    {
      "Name" = "ec2-${var.service}-${var.environment}-homepage"
    },
  )
}

###################################################################################
# Admin(temporary)
###################################################################################
module "ec2_admin" {
  source = "terraform-aws-modules/ec2-instance/aws"
  create = var.create_ec2_admin

  name = "ec2-${var.service}-${var.environment}-admin"

  instance_type               = var.ec2_admin_instance_type
  availability_zone           = element(local.azs, 0)
  subnet_id                   = data.aws_subnets.app_vm_a.ids[0]
  vpc_security_group_ids      = [module.security_group_ec2_admin.security_group_id]
  associate_public_ip_address = false
  disable_api_stop            = false
  disable_api_termination     = true
  # https://docs.aws.amazon.com/ko_kr/AWSEC2/latest/UserGuide/hibernating-prerequisites.html#hibernation-prereqs-supported-amis
  hibernation                 = false
  user_data_base64            = base64encode(file("./user_data.sh"))
  user_data_replace_on_change = true
  private_ip                  = var.ec2_admin_private_ip

  metadata_options = {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  enable_volume_tags = false
  root_block_device = [
    {
      encrypted   = true
      kms_key_id  = data.aws_kms_key.ebs.arn
      volume_type = "gp3"
      volume_size = var.ec2_root_volume_size
      tags = merge(
        local.tags,
        {
          "Name" = "ebs-${var.service}-${var.environment}-admin-root"
        },
      )
    },
  ]

  tags = merge(
    local.tags,
    {
      "Name" = "ec2-${var.service}-${var.environment}-admin"
    },
  )
}

################################################################################
# ELB Module
# reference: https://github.com/terraform-aws-modules/terraform-aws-alb
################################################################################
module "alb_vm" {
  source = "terraform-aws-modules/alb/aws"
  create = var.create_alb_vm

  name     = "alb-${var.service}-${var.environment}-vm"
  vpc_id   = data.aws_vpc.vpc.id
  subnets  = data.aws_subnets.elb.ids
  internal = true

  # Security Group
  create_security_group = false
  security_groups       = [module.security_group_alb_vm.security_group_id]
  # security_group_name            = "scg-${var.service}-${var.environment}-alb-vm"
  # security_group_use_name_prefix = false
  # security_group_description     = "Security group for VM ALB ingress"
  # security_group_tags = merge(
  #   local.tags,
  #   {
  #     "Name" = "scg-${var.service}-${var.environment}-alb-vm"
  #   },
  # )

  # security_group_ingress_rules = {
  #   all_http = {
  #     from_port   = 80
  #     to_port     = 80
  #     ip_protocol = "tcp"
  #     description = "HTTP web traffic"
  #     cidr_ipv4   = "0.0.0.0/0"
  #   }
  #   all_https = {
  #     from_port   = 443
  #     to_port     = 443
  #     ip_protocol = "tcp"
  #     description = "HTTPS web traffic"
  #     cidr_ipv4   = "0.0.0.0/0"
  #   }
  # }
  # security_group_egress_rules = {
  #   all = {
  #     ip_protocol = "-1"
  #     cidr_ipv4   = "10.0.0.0/16"
  #   }
  # }

  # access_logs = {
  #   bucket = "my-alb-logs"
  # }

  # listeners = {
  #   ex-http-https-redirect = {
  #     port     = 80
  #     protocol = "HTTP"
  #     redirect = {
  #       port        = "443"
  #       protocol    = "HTTPS"
  #       status_code = "HTTP_301"
  #     }
  #   }
  #   ex-https = {
  #     port            = 443
  #     protocol        = "HTTPS"
  #     certificate_arn = "arn:aws:iam::123456789012:server-certificate/test_cert-123456789012"

  #     forward = {
  #       target_group_key = "ex-instance"
  #     }
  #   }
  # }

  # target_groups = {
  #   ex-instance = {
  #     name_prefix = "h1"
  #     protocol    = "HTTP"
  #     port        = 80
  #     target_type = "instance"
  #     target_id   = "i-0f6d38a07d50d080f"
  #   }
  # }

  tags = merge(
    local.tags,
    {
      "Name" = "alb-${var.service}-${var.environment}-vm"
    },
  )
}

module "nlb_vm" {
  source = "terraform-aws-modules/alb/aws"
  create = var.create_nlb_vm

  name               = "nlb-${var.service}-${var.environment}-vm"
  load_balancer_type = "network"
  vpc_id             = data.aws_vpc.vpc.id
  subnets            = data.aws_subnets.elb.ids
  internal           = true

  # Security Group
  create_security_group = false
  security_groups       = [module.security_group_nlb_vm.security_group_id]
  # enforce_security_group_inbound_rules_on_private_link_traffic = "on"
  # security_group_ingress_rules = {
  #   all_http = {
  #     from_port   = 80
  #     to_port     = 82
  #     ip_protocol = "tcp"
  #     description = "HTTP web traffic"
  #     cidr_ipv4   = "0.0.0.0/0"
  #   }
  #   all_https = {
  #     from_port   = 443
  #     to_port     = 445
  #     ip_protocol = "tcp"
  #     description = "HTTPS web traffic"
  #     cidr_ipv4   = "0.0.0.0/0"
  #   }
  # }
  # security_group_egress_rules = {
  #   all = {
  #     ip_protocol = "-1"
  #     cidr_ipv4   = "10.0.0.0/16"
  #   }
  # }

  # access_logs = {
  #   bucket = "my-nlb-logs"
  # }

  # listeners = {
  #   ex-tcp-udp = {
  #     port     = 81
  #     protocol = "TCP_UDP"
  #     forward = {
  #       target_group_key = "ex-target"
  #     }
  #   }

  #   ex-udp = {
  #     port     = 82
  #     protocol = "UDP"
  #     forward = {
  #       target_group_key = "ex-target"
  #     }
  #   }

  #   ex-tcp = {
  #     port     = 83
  #     protocol = "TCP"
  #     forward = {
  #       target_group_key = "ex-target"
  #     }
  #   }

  #   ex-tls = {
  #     port            = 84
  #     protocol        = "TLS"
  #     certificate_arn = "arn:aws:iam::123456789012:server-certificate/test_cert-123456789012"
  #     forward = {
  #       target_group_key = "ex-target"
  #     }
  #   }
  # }

  # target_groups = {
  #   ex-target = {
  #     name_prefix = "pref-"
  #     protocol    = "TCP"
  #     port        = 80
  #     target_type = "ip"
  #     target_id   = "10.0.47.1"
  #   }
  # }

  tags = merge(
    local.tags,
    {
      "Name" = "nlb-${var.service}-${var.environment}-vm"
    },
  )
}

module "nlb_container" {
  source = "terraform-aws-modules/alb/aws"
  create = var.create_nlb_conatiner

  name               = "nlb-${var.service}-${var.environment}-container"
  load_balancer_type = "network"
  vpc_id             = data.aws_vpc.vpc.id
  subnets            = data.aws_subnets.elb.ids
  internal           = true

  create_security_group = false
  security_groups       = [module.security_group_nlb_container.security_group_id]

  tags = merge(
    local.tags,
    {
      "Name" = "nlb-${var.service}-${var.environment}-container"
    },
  )
}

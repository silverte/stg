################################################################################
# ElastiCache Module
# reference: https://github.com/terraform-aws-modules/terraform-aws-elasticache
################################################################################

module "elasticache-data" {
  source = "terraform-aws-modules/elasticache/aws"
  create = var.create_elasticache

  cluster_id                 = "ec-${var.service}-${var.environment}-${var.elasticache_cluster_name}"
  create_cluster             = true
  cluster_mode_enabled       = false
  create_replication_group   = false
  multi_az_enabled           = false
  automatic_failover_enabled = false

  engine_version = var.elasticache_cluster_engine_version
  port           = var.elasticache_cluster_port
  node_type      = var.elasticache_cluster_instance_class

  # maintenance_window = "sun:05:00-sun:09:00"
  # apply_immediately  = true
  auto_minor_version_upgrade = false

  # Security Group
  create_security_group = false
  security_group_ids    = [module.security_group_elasticache_data.security_group_id]

  at_rest_encryption_enabled = true
  transit_encryption_enabled = false

  # Subnet Group
  subnet_group_name        = "ecsg-${var.service}-${var.environment}"
  subnet_group_description = "elasticache subnet group"
  subnet_ids               = data.aws_subnets.app_pod.ids
  # availability_zone = module.vpc.azs
  # Sandbox, Dev, Stage Only
  availability_zone = element(local.azs, 0)

  # Parameter Group
  create_parameter_group      = true
  parameter_group_name        = "ecpg-${var.service}-${var.environment}-${var.elasticache_cluster_name}"
  parameter_group_family      = var.elasticache_cluster_parameter_group_family
  parameter_group_description = "elasticache parameter group"
  parameters                  = []

  tags = merge(
    local.tags,
    {
      "Name" = "ec-${var.service}-${var.environment}-${var.elasticache_cluster_name}"
    },
  )
}

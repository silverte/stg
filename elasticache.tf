################################################################################
# ElastiCache Module
# reference: https://github.com/terraform-aws-modules/terraform-aws-elasticache
################################################################################

module "elasticache-data" {
  source = "terraform-aws-modules/elasticache/aws"
  create = var.create_elasticache

  create_cluster       = false
  cluster_mode_enabled = false

  create_replication_group = true
  replication_group_id     = "ec-${var.service}-${var.environment}-${var.elasticache_cluster_name}"
  description              = "ElastiCache replication group"

  multi_az_enabled           = false
  automatic_failover_enabled = false
  num_cache_nodes            = 1

  engine_version = var.elasticache_cluster_engine_version
  port           = var.elasticache_cluster_port
  node_type      = var.elasticache_cluster_instance_class

  auto_minor_version_upgrade = false

  # Security Group
  create_security_group = false
  security_group_ids    = [module.security_group_elasticache_data.security_group_id]

  at_rest_encryption_enabled = true
  transit_encryption_enabled = false

  # Subnet Group
  subnet_group_name            = "ecsg-${var.service}-${var.environment}"
  subnet_group_description     = "elasticache subnet group"
  subnet_ids                   = data.aws_subnets.app_pod.ids
  preferred_availability_zones = local.azs

  # Parameter Group
  create_parameter_group      = true
  parameter_group_name        = "ecpg-${var.service}-${var.environment}-${var.elasticache_cluster_name}"
  parameter_group_family      = var.elasticache_cluster_parameter_group_family
  parameter_group_description = "elasticache parameter group"
  parameters                  = []

  # log_delivery_configuration = {}
  apply_immediately = true

  tags = merge(
    local.tags,
    {
      "Name" = "ec-${var.service}-${var.environment}-${var.elasticache_cluster_name}"
    },
  )
}

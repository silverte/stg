###################################################
# RDS Common Variables
###################################################
# create_db_subnet_group
variable "create_db_subnet_group" {
  description = "Whether to create a database subnet group"
  type        = bool
  default     = true
}

###################################################
# RDS MariaDB
###################################################
# RDS Name
variable "rds_mariadb_name" {
  description = "RDS Name"
  type        = string
  default     = "mariadb-solution"
}

# RDS Engine
variable "rds_mariadb_engine" {
  description = "RDS Engine"
  type        = string
  default     = "mariadb"
}

# RDS Engine Version
variable "rds_mariadb_engine_version" {
  description = "RDS Engine Version"
  type        = string
  default     = "10.11.8"
}

# RDS Inatance Class
variable "rds_mariadb_instance_class" {
  description = "RDS Instance Class"
  type        = string
  default     = ""
}

# RDS Family
variable "rds_mariadb_family" {
  description = "RDS DB parameter group"
  type        = string
  default     = "mariadb10.11"
}

# RDS Major Engine Version
variable "rds_mariadb_major_engine_version" {
  description = "RDS DB option group"
  type        = string
  default     = "10.11"
}

# RDS Allocated Storage
variable "rds_mariadb_allocated_storage" {
  description = "RDS Allocated Storage"
  type        = number
  default     = 500
}

# RDS DB Name
variable "rds_mariadb_db_name" {
  description = "RDS DB Name"
  type        = string
  default     = ""
}

# RDS MariaDB Username
variable "rds_mariadb_username" {
  description = "RDS MariaDB As-Is Username"
  type        = string
  default     = ""
}

# RDS MariaDB Port
variable "rds_mariadb_port" {
  description = "RDS MariaDB As-Is Port"
  type        = number
  default     = 3306
}

# Whether to create an MariaDB (True or False)
variable "create_mariadb" {
  description = "Whether to create an MariaDB As-Is"
  type        = bool
  default     = false
}

###################################################
# RDS Oracle
###################################################

# RDS Name
variable "rds_oracle_name" {
  description = "RDS Name"
  type        = string
  default     = "oracle-solution"
}

# RDS Engine
variable "rds_oracle_engine" {
  description = "RDS Engine"
  type        = string
  default     = "oracle-ee"
}

# RDS Engine Version
variable "rds_oracle_engine_version" {
  description = "RDS Engine Version"
  type        = string
  default     = "19"
}

# RDS Instance Class
variable "rds_oracle_instance_class" {
  description = "RDS Instance Class"
  type        = string
  default     = "db.t3.large"
}

# RDS Family
variable "rds_oracle_family" {
  description = "RDS DB parameter group"
  type        = string
  default     = "oracle-ee-19"
}

# RDS Major Engine Version
variable "rds_oracle_major_engine_version" {
  description = "RDS DB option group"
  type        = string
  default     = "19"
}

# RDS Allocated Storage
variable "rds_oracle_allocated_storage" {
  description = "RDS Allocated Storage"
  type        = number
  default     = 500
}

# RDS Name
variable "rds_oracle_db_name" {
  description = "RDS Database Name"
  type        = string
  default     = "oracle"
}

# RDS Oracle Username
variable "rds_oracle_username" {
  description = "RDS Oracle Username"
  type        = string
  default     = ""
}

# RDS Oracle Port
variable "rds_oracle_port" {
  description = "RDS Oracle Port"
  type        = number
  default     = 1521
}

# Whether to create an Oracle (True or False)
variable "create_oracle" {
  description = "Whether to create an Oracle"
  type        = bool
  default     = false
}

###################################################
# RDS Aurora PostgreSQL
###################################################
# RDS Aurora Cluster Name
variable "rds_aurora_cluster_name" {
  description = "RDS Aurora Cluster Name"
  type        = string
  default     = "aurora-postgresql"
}

# RDS Aurora Cluster Engine
variable "rds_aurora_cluster_engine" {
  description = "RDS Aurora Cluster Engine"
  type        = string
  default     = "aurora-postgresql"
}

# RDS Aurora Cluster Engine Version
variable "rds_aurora_cluster_engine_version" {
  description = "RDS Aurora Cluster Engine Version"
  type        = string
  default     = "14.7"
}

# RDS Aurora Cluster Parameter Group Family
variable "rds_aurora_cluster_pg_family" {
  description = "RDS Aurora Cluster Parameter Group Family"
  type        = string
  default     = "aurora-postgresql14"
}

# RDS Aurora Cluster Instance Class
variable "rds_aurora_cluster_instance_class" {
  description = "RDS Aurora Cluster Instance Class"
  type        = string
  default     = ""
}

# RDS Aurora Cluster Database Name
variable "rds_aurora_cluster_database_name" {
  description = "RDS Aurora Cluster Database Name"
  type        = string
  default     = "aurora_db"
}

# RDS Aurora Master Username
variable "rds_aurora_master_username" {
  description = "RDS Aurora Master Username"
  type        = string
  default     = ""
}

# RDS Aurora Port
variable "rds_aurora_port" {
  description = "RDS Aurora Port"
  type        = number
  default     = 5432
}

# Whether to create an Aurora PostreSQL (True or False)
variable "create_aurora_postresql" {
  description = "Whether to create an Aurora PostreSQL"
  type        = bool
  default     = false
}

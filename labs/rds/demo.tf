resource "aws_db_instance" "instance" {
  apply_immediately                     = var.apply_immediately
  allocated_storage                     = var.allocated_storage
  max_allocated_storage                 = var.max_allocated_storage
  backup_retention_period               = var.backup_retention_period
  backup_window                         = var.preferred_backup_window
  db_subnet_group_name                  = aws_db_subnet_group.subnet_group.id
  deletion_protection                   = var.deletion_protection
  engine                                = "postgres"
  engine_version                        = var.engine_version
  identifier                            = "${var.env}-${lower(var.name)}-${var.cluster_name}-${lower(random_id.instance_name_suffix.hex)}"
  instance_class                        = var.instance_class
  maintenance_window                    = var.preferred_maintenance_window
  db_name                               = var.db_name
  password                              = random_string.password.result
  port                                  = var.port == "" ? "5432" : var.port
  parameter_group_name                  = var.parameter
  enabled_cloudwatch_logs_exports       = ["postgresql", "upgrade"]
  skip_final_snapshot                   = var.skip_final_snapshot
  storage_encrypted                     = var.storage_encryption
  storage_type                          = var.storage_type
  username                              = var.username
  publicly_accessible                   = false
  multi_az                              = var.multi_az
  performance_insights_enabled          = var.enable_performance_insights
  performance_insights_retention_period = var.enable_performance_insights ? var.performance_insights_retention : null
  performance_insights_kms_key_id       = var.enable_performance_insights ? "${aws_kms_key.kms_key_performance_insights[0].arn}" : null
  final_snapshot_identifier             = var.skip_final_snapshot ? null : "${var.env}-${var.name}-${var.cluster_name}-${random_id.snapshot_id.hex}-final-snap"
  # replicate_source_db             = var.replicate_source_db
  kms_key_id                 = var.storage_encryption ? "${aws_kms_key.kms_key[0].arn}" : null
  copy_tags_to_snapshot      = var.copy_tags_to_snapshot
  monitoring_interval        = var.monitoring_interval
  monitoring_role_arn        = aws_iam_role.rds_enhanced_monitoring.arn
  auto_minor_version_upgrade = var.auto_minor_version_upgrade

  vpc_security_group_ids = [
    aws_security_group.rds_sg.id,
  ]

  lifecycle {
    ignore_changes = [
      username,
      password,
    ]
  }
  tags = {
    "Name"           = var.infrastructure_name
    "Application"    = var.application
    "BillingTeam"    = var.billing_team
    "Environment"    = var.env
    "CostCenter"     = var.cost_center
    "Owner"          = var.owner
    "PrincipalId"    = var.principal_id
    "SubBillingTeam" = var.sub_billing_team
    "ResourceName"   = var.resource_name
    "ProjectName"    = var.project_name
    "BusinessUnit"   = var.bu
    "map-migrated"   = var.map_migrated
  }
}
#################################################
# RDS Cluster
#################################################
resource "aws_rds_cluster" "this" {
  cluster_identifier              = var.db.cluster_identifier
  engine                          = var.db.engine
  engine_version                  = var.db.engine_version
  availability_zones              = var.db.az
  db_subnet_group_name            = aws_db_subnet_group.main.name
  vpc_security_group_ids          = var.sg_id
  enabled_cloudwatch_logs_exports = ["audit", "error", "slowquery"]
  copy_tags_to_snapshot           = true
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.mysql5.name
  database_name                   = var.db.db_name
  master_username                 = var.username
  master_password                 = var.password
  storage_encrypted               = true
  backup_retention_period         = var.db.bk_retention
  preferred_backup_window         = var.db.bk_window
  skip_final_snapshot             = true
  apply_immediately               = true

  lifecycle {
    ignore_changes = [availability_zones]
  }
}

resource "aws_rds_cluster_instance" "this" {
  count                = var.db.instance_num
  identifier           = "${var.db.instance_prefix}0${count.index + 1}" //start num => 01
  cluster_identifier   = aws_rds_cluster.this.id
  instance_class       = "db.r3.large"
  db_subnet_group_name = aws_db_subnet_group.main.name
  engine               = var.db.engine
  engine_version       = var.db.engine_version
}
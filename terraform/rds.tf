resource "random_password" "password" {
  length           = 16
  special          = true
}

resource "aws_db_instance" "default" {
  allocated_storage      = 10
  db_name                = local.name
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t3.micro"
  db_subnet_group_name   = aws_db_subnet_group.default.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  username               = "foo"
  password               = random_password.password.result
  deletion_protection    = false

  ### スナップショット関連
  skip_final_snapshot = true

  ## 最後に作成されるスナップショットの名前
  # final_snapshot_identifier = "final_snapshot"

  ### バックアップ
  backup_target = "region"
  ## バックアップの保持期間0-35, 0以外の値を指定で自動バックアップの有効化
  backup_retention_period = 7
  #backup_window = "09:23-10:10"
  #delete_automated_buckups = true

  ### 復元
  #restore_to_point_in_time {
  #  restore_time
  #  source_db_instance_identifier
  #  source_db_instance_automated_backups_arn
  #  source_dbi_resource_id
  #  use_latest_restorable_time
  #}

  ## 指定したスナップショットからの作成
  #snapshot_identifier = 

  ### 暗号化
  storage_encrypted = true
  kms_key_id = aws_kms_key.rds_key.arn

  ### メンテナンス
  maintenance_window = "Mon:00:00-Mon:03:00"
  auto_minor_version_upgrade = true

  ### モニタリング
  ## 0で無効 (秒単位)
  #monitoring_interval = 60
  ## cloudwatch logsに送信するためのarn
  #monitoring_role_arn = "arn:....."

  #performance_insights_enabled = true
  #performance_insights_kms_key_id = 
  #performance_insights_retention_period = 7

  ### ブルー/グリーンアップデート
  blue_green_update {
    enabled = false
  }
}

resource "aws_db_subnet_group" "default" {
  name       = "${local.name}-subnet-group"
  subnet_ids = module.vpc.private_subnets
}

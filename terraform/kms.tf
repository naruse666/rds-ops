resource "aws_kms_key" "rds_key" {
  deletion_window_in_days = 7
}

resource "aws_db_subnet_group" "main" {
  name       = "db_sg"
  subnet_ids = var.subnet_ids
}
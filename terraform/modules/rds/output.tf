output "engine" {
  value = aws_rds_cluster.this.engine
}

output "endpoint" {
  value = aws_rds_cluster.this.endpoint
}

output "port" {
  value = aws_rds_cluster.this.port
}

output "dbname" {
  value = aws_rds_cluster.this.database_name
}

output "identifier" {
  value = aws_rds_cluster.this.cluster_identifier
}

output "username" {
  value = aws_rds_cluster.this.master_username
}

output "password" {
  value = aws_rds_cluster.this.master_password
}
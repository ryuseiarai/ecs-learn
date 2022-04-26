#################################################
# Scret Manager
#################################################
data "aws_kms_key" "secretsmanager" {
  key_id = "alias/aws/secretsmanager"
}

resource "aws_secretsmanager_secret" "mysql" {
  name       = "${terraform.workspace}/mysql"
  kms_key_id = data.aws_kms_key.secretsmanager.arn
}

resource "aws_secretsmanager_secret_version" "mysql" {
  secret_id = aws_secretsmanager_secret.mysql.id
  secret_string = jsonencode({
    username : module.rds_primary.username
    password : module.rds_primary.password
    engine : module.rds_primary.engine
    host : module.rds_primary.endpoint
    port : module.rds_primary.port
    dbname : module.rds_primary.dbname
    dbClusterIdentifier : module.rds_primary.identifier
  })

  depends_on = [
    module.rds_primary
  ]
}
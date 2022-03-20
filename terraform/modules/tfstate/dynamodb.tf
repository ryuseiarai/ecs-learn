#################################################
# DynamoDB
#################################################
resource "aws_dynamodb_table" "tstate_lock" {
  count          = terraform.workspace == "common" ? 1 : 0
  name           = var.dynamo_table_name
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

}
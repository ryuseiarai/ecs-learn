variable "tfstate" {
  default = {
    bucket_name       = "common-s3-bucket-tfstate"
    dynamo_table_name = "common-dynamodb-table-tfstate"
  }
}

variable "ip" {
  default = {}
}
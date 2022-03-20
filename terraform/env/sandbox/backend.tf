terraform {
  backend "s3" {
    bucket         = "common-s3-bucket-tfstate"
    key            = "sandbox/terraform.tstate"
    region         = "ap-northeast-1"
    dynamodb_table = "common-dynamodb-table-tfstate"
  }
}
#################################################
# S3
#################################################
resource "aws_s3_bucket" "tfstate" {
  count  = terraform.workspace == "common" ? 1 : 0
  bucket = var.bucket_name
}

resource "aws_s3_bucket_acl" "tfstate" {
  count  = terraform.workspace == "common" ? 1 : 0
  bucket = resource.aws_s3_bucket.tfstate[0].id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "tfstate" {
  count  = terraform.workspace == "common" ? 1 : 0
  bucket = resource.aws_s3_bucket.tfstate[0].id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tfstate" {
  count  = terraform.workspace == "common" ? 1 : 0
  bucket = resource.aws_s3_bucket.tfstate[0].id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_policy" "allow_accress_from_myhome" {
  count  = terraform.workspace == "common" ? 1 : 0
  bucket = resource.aws_s3_bucket.tfstate[0].id
  policy = data.aws_iam_policy_document.allow_access_from_myhome.json
}
#################################################
# S3 bucket policy
#################################################

# 自宅のIPのみアクセス許可する
data "aws_iam_policy_document" "allow_access_from_myhome" {
  statement {
    sid    = "IPAllow"
    effect = "Deny"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions = [
      "s3:*"
    ]
    resources = [
      "${resource.aws_s3_bucket.tfstate[0].arn}/*"
    ]
    condition {
      test     = "NotIpAddress"
      variable = "aws:SourceIp"
      values = [
        var.ip.myhome,
      ]
    }
  }
}
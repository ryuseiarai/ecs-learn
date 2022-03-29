#################################################
# IAM Role
#################################################
# Role: cloud9 can access ECR
resource "aws_iam_role" "cloud9_ecr_role" {
  name               = "${terraform.workspace}-cloud9-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_policy.json

  inline_policy {
    name   = "${terraform.workspace}-AccessingECRRepositoryPolicy"
    policy = data.aws_iam_policy_document.cloud9_ecr_policy.json
  }
}

# TODO: インスタンスプロファイル
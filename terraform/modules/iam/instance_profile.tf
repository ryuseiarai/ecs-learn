#################################################
# IAM Instance profile
#################################################
resource "aws_iam_instance_profile" "cloud9_profile" {
  name = "${terraform.workspace}_cloud9_profile"
  role = resource.aws_iam_role.cloud9_ecr_role.name
}
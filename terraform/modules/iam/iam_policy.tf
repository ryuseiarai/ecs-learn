resource "aws_iam_policy" "ecs_get_secrets" {
  name   = "${terraform.workspace}-GettingSecretsPolicy"
  policy = data.aws_iam_policy_document.secrets_manager.json
}
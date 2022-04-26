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

# Role: ECS code deploy
data "aws_iam_policy" "AWSCodeDeployRoleForECS" {
  arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
}

resource "aws_iam_role" "ecs_codedeploy_role" {
  name               = "${terraform.workspace}-ecs-codedeploy-role"
  assume_role_policy = data.aws_iam_policy_document.codedeploy_policy.json
}

resource "aws_iam_role_policy_attachment" "ecs_codedeploy" {
  role       = aws_iam_role.ecs_codedeploy_role.name
  policy_arn = data.aws_iam_policy.AWSCodeDeployRoleForECS.arn
}

# Role: ECS Task Execution
data "aws_iam_policy" "AmazonECSTaskExecutionRolePolicy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "${terraform.workspace}-ecs-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_policy.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_01" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = data.aws_iam_policy.AmazonECSTaskExecutionRolePolicy.arn
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_02" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.ecs_get_secrets.arn
}
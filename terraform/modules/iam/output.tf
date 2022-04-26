output "role_arn" {
  value = {
    ecs_codedeploy     = aws_iam_role.ecs_codedeploy_role.arn
    ecs_task_execution = aws_iam_role.ecs_task_execution_role.arn
  }
}
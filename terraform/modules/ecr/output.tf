output "ecr_arns" {
  value = { for i in var.ecr.private : i.name => aws_ecr_repository.ecr[i.name].arn }
}
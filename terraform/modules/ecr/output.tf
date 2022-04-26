output "ecr_arns" {
  value = { for i in var.ecr.private : i.name => aws_ecr_repository.ecr[i.name].arn }
}

output "frontend_uri" {
  value = aws_ecr_repository.ecr["sandbox-frontend"].repository_url
}

output "backend_uri" {
  value = aws_ecr_repository.ecr["sandbox-backend"].repository_url
}
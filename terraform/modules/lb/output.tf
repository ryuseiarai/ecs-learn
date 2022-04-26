output "target_group_arn" {
  description = "ARN of LB Target Group."
  value       = { for p in var.lb.tg : p.name => aws_lb_target_group.this[p.name].arn }
}

output "dns_name" {
  description = "A Record of LB."
  value       = { for p in var.lb.lb : p.name => aws_lb.this[p.name].dns_name }
}
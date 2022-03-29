output "vpc_id" {
  description = "ID of VPC."
  value       = resource.aws_vpc.vpc.id
}

output "sg_ids" {
  description = "IDs of Security group."
  value       = { for p in toset(var.sg) : p => resource.aws_security_group.sg[p].id }
}

output "subnet_ids" {
  description = "IDs of Subnet."
  value       = { for p in var.subnet : p.name => resource.aws_subnet.subnet[p.name].id }
}

output "route_table_ids" {
  description = "IDs of Route table."
  value       = { for p in var.route_table : p.group => resource.aws_route_table.route_table[p.group].id }
}
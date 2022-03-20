#################################################
# Route Table
#################################################
resource "aws_route_table" "route_table" {
  for_each = { for i in var.route_table : i.group => i }
  vpc_id   = resource.aws_vpc.vpc.id

  dynamic "route" {
    for_each = each.value.group == "ingress" || each.value.group == "bastion" ? [1] : []
    content {
      cidr_block = "0.0.0.0/0"
      gateway_id = resource.aws_internet_gateway.igw.id
    }
  }

  tags = {
    Name = each.value.name
  }
}

resource "aws_route_table_association" "subnet_association" {
  for_each       = { for i in var.subnet : i.name => i }
  subnet_id      = resource.aws_subnet.subnet["${each.value.name}"].id
  route_table_id = resource.aws_route_table.route_table["${each.value.group}"].id
}
resource "aws_ec2_managed_prefix_list" "prefix" {
  for_each       = { for i in var.prefix_list : i.name => i }
  name           = each.value.name
  address_family = each.value.address_family
  max_entries    = each.value.max_entries

  dynamic "entry" {
    for_each = toset(each.value.entry_list)
    content {
      cidr = resource.aws_subnet.subnet["${entry.value}"].cidr_block
    }
  }

  tags = {
    Env = each.value.name
  }
}
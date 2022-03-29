#################################################
# Secuerity Group
#################################################
resource "aws_security_group" "sg" {
  for_each = toset(var.sg)
  name     = each.value
  vpc_id   = resource.aws_vpc.vpc.id

  tags = {
    Name = each.value
  }
}
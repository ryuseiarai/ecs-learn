#################################################
# VPC
#################################################

# VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc.cidr

  tags = {
    Name = var.vpc.name
  }
}

#Subnet
resource "aws_subnet" "subnet" {
  for_each          = { for i in var.subnet : i.name => i }
  vpc_id            = resource.aws_vpc.vpc.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name = each.value.name
  }
}

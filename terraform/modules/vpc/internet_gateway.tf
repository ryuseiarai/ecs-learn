#################################################
# Internet Gateway
#################################################
resource "aws_internet_gateway" "igw" {
  vpc_id = resource.aws_vpc.vpc.id

  tags = {
    Name = var.igw.name
  }
}
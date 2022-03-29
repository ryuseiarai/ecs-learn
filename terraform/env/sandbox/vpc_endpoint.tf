#################################################
# VPC endpoint
#################################################

# ECR
data "aws_vpc_endpoint_service" "ecr_api" {
  service = var.vpc_endpoint_pri.ecr_api.service_name
}

resource "aws_vpc_endpoint" "ecr_api" {
  service_name        = data.aws_vpc_endpoint_service.ecr_api.service_name
  vpc_id              = module.vpc_primary.vpc_id
  vpc_endpoint_type   = var.vpc_endpoint_pri.ecr_api.type
  private_dns_enabled = var.vpc_endpoint_pri.ecr_api.dns
  subnet_ids = [
    module.vpc_primary.subnet_ids["sandbox-subnet-private-egress-1a"],
    module.vpc_primary.subnet_ids["sandbox-subnet-private-egress-1c"],
  ]
  security_group_ids = [module.vpc_primary.sg_ids["sabdbox-sg-egress"]]

  tags = {
    Name = var.vpc_endpoint_pri.ecr_api.name
  }
}

data "aws_vpc_endpoint_service" "ecr_dkr" {
  service = var.vpc_endpoint_pri.ecr_dkr.service_name
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  service_name        = data.aws_vpc_endpoint_service.ecr_dkr.service_name
  vpc_id              = module.vpc_primary.vpc_id
  vpc_endpoint_type   = var.vpc_endpoint_pri.ecr_dkr.type
  private_dns_enabled = var.vpc_endpoint_pri.ecr_dkr.dns
  subnet_ids = [
    module.vpc_primary.subnet_ids["sandbox-subnet-private-egress-1a"],
    module.vpc_primary.subnet_ids["sandbox-subnet-private-egress-1c"],
  ]
  security_group_ids = [module.vpc_primary.sg_ids["sabdbox-sg-egress"]]

  tags = {
    Name = var.vpc_endpoint_pri.ecr_dkr.name
  }
}

# S3 Gateway Endpoint
data "aws_vpc_endpoint_service" "s3" {
  service      = var.vpc_endpoint_pri.s3.service_name
  service_type = var.vpc_endpoint_pri.s3.type
}

resource "aws_vpc_endpoint" "s3" {
  service_name      = data.aws_vpc_endpoint_service.s3.service_name
  vpc_id            = module.vpc_primary.vpc_id
  vpc_endpoint_type = var.vpc_endpoint_pri.s3.type
  #private_dns_enabled = var.vpc_endpoint_pri.s3.dns
  route_table_ids = [module.vpc_primary.route_table_ids["app"]]

  tags = {
    Name = var.vpc_endpoint_pri.s3.name
  }
}
# Environment: Sandbox
# Terraform Workspace: sandbox
# Latest update: 2022/03/20

#################################################
# VPC
#################################################
module "vpc_primary" {
  source      = "../../modules/vpc"
  vpc         = var.vpc_pri
  subnet      = var.subnet_pri
  igw         = var.igw_pri
  route_table = var.route_table_pri
  sg          = var.sg_pri
}
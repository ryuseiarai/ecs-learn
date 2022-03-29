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
  prefix_list = var.prefix_list_pri
}

# Route table rules are defined in "./route_table_rule.tf".
# Security group rules are defined in "./security_group_rule.tf".

#################################################
# ECR
#################################################
module "ecr_primary" {
  source = "../../modules/ecr"
  ecr    = var.ecr_pri
}

# VPC Endpoint are defined in "./vpc_endpoint.tf".

#################################################
# IAM
#################################################
module "ima_primary" {
  source   = "../../modules/iam"
  ecr_arns = module.ecr_primary.ecr_arns
}
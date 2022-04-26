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
module "iam_primary" {
  source   = "../../modules/iam"
  ecr_arns = module.ecr_primary.ecr_arns
  depends_on = [
    module.ecr_primary
  ]
}

#################################################
# LB
#################################################
module "lb_primary" {
  source     = "../../modules/lb"
  lb         = var.lb_pri
  vpc_id     = module.vpc_primary.vpc_id
  sg_ids     = module.vpc_primary.sg_ids
  subnet_ids = module.vpc_primary.subnet_ids
  depends_on = [
    module.vpc_primary
  ]
}

################################################
# RDS
################################################
module "rds_primary" {
  source     = "../../modules/rds"
  db         = var.db_pri
  username   = var.db_admin.username
  password   = var.db_admin.password
  sg_id      = [module.vpc_primary.sg_ids[var.sg_pri[4]]]
  subnet_ids = [module.vpc_primary.subnet_ids[var.subnet_pri[4].name], module.vpc_primary.subnet_ids[var.subnet_pri[5].name]]
}

#################################################
# ECS
#################################################
module "ecs_primary" {
  source     = "../../modules/ecs"
  ecs        = var.ecs_pri
  ecr        = module.ecr_primary
  iam        = module.iam_primary
  sg_ids     = module.vpc_primary.sg_ids
  subnet_ids = module.vpc_primary.subnet_ids
  lb         = module.lb_primary
  db         = jsondecode(aws_secretsmanager_secret_version.mysql.secret_string)

  depends_on = [
    aws_secretsmanager_secret_version.mysql
  ]
}
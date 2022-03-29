#################################################
# Security Group rule
#################################################

# Ingress Rule
## sabdbox-sg-ingress
resource "aws_security_group_rule" "sg-ingress_ingress_ipv4_http_all" {
  type              = "ingress"
  description       = "from 0.0.0.0/0:80"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.vpc_primary.sg_ids["${var.sg_pri[0]}"]
}

resource "aws_security_group_rule" "sg-ingress_ingress_ipv6_http_all" {
  type              = "ingress"
  description       = "from ::/0:80"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = module.vpc_primary.sg_ids["${var.sg_pri[0]}"]
}

## sabdbox-sg-frontend
resource "aws_security_group_rule" "sg-frontend_ingress_ipv4_http_sg-ingress" {
  type              = "ingress"
  description       = "HTTP for front container"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = [var.subnet_pri[0].cidr, var.subnet_pri[1].cidr, var.subnet_pri[2].cidr]
  security_group_id = module.vpc_primary.sg_ids["${var.sg_pri[1]}"]
}

## sabdbox-sg-internal
resource "aws_security_group_rule" "sg-internal_ingress_ipv4_http_sg-frontend" {
  type              = "ingress"
  description       = "HTTP for internal lb"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = [var.subnet_pri[3].cidr, var.subnet_pri[4].cidr, var.subnet_pri[5].cidr]
  security_group_id = module.vpc_primary.sg_ids["${var.sg_pri[2]}"]
}

resource "aws_security_group_rule" "sg-internal_ingress_ipv4_http_sg-bastion" {
  type              = "ingress"
  description       = "HTTP for internal lb"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = [var.subnet_pri[9].cidr]
  security_group_id = module.vpc_primary.sg_ids["${var.sg_pri[2]}"]
}

## sabdbox-sg-backend
resource "aws_security_group_rule" "sg-backend_ingress_ipv4_http_sg-internal" {
  type              = "ingress"
  description       = "HTTP for backend container"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = [var.subnet_pri[3].cidr, var.subnet_pri[4].cidr, var.subnet_pri[5].cidr]
  security_group_id = module.vpc_primary.sg_ids["${var.sg_pri[3]}"]
}

resource "aws_security_group_rule" "sg-backend_ingress_ipv4_http_sg-bastion" {
  type              = "ingress"
  description       = "HTTP for backend container"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = [var.subnet_pri[9].cidr]
  security_group_id = module.vpc_primary.sg_ids["${var.sg_pri[3]}"]
}

## sabdbox-sg-db
resource "aws_security_group_rule" "sg-db_ingress_ipv4_http_sg-frontend" {
  type              = "ingress"
  description       = "MySQL protocol from frontend App"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  cidr_blocks       = [var.subnet_pri[3].cidr, var.subnet_pri[4].cidr, var.subnet_pri[5].cidr]
  security_group_id = module.vpc_primary.sg_ids["${var.sg_pri[4]}"]
}

resource "aws_security_group_rule" "sg-db_ingress_ipv4_http_sg-backend" {
  type              = "ingress"
  description       = "MySQL protocol from backend App"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  cidr_blocks       = [var.subnet_pri[6].cidr, var.subnet_pri[7].cidr, var.subnet_pri[8].cidr]
  security_group_id = module.vpc_primary.sg_ids["${var.sg_pri[4]}"]
}

resource "aws_security_group_rule" "sg-db_ingress_ipv4_http_sg-bastion" {
  type              = "ingress"
  description       = "MySQL protocol from bastion"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  cidr_blocks       = [var.subnet_pri[9].cidr]
  security_group_id = module.vpc_primary.sg_ids["${var.sg_pri[4]}"]
}

## bastion-sg-ingress
resource "aws_security_group_rule" "sg-bastion_ingress_ipv4_http_all" {
  type              = "ingress"
  description       = "from 0.0.0.0/0:80"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.vpc_primary.sg_ids["${var.sg_pri[5]}"]
}

resource "aws_security_group_rule" "sg-bastion_ingress_ipv6_http_all" {
  type              = "ingress"
  description       = "from ::/0:80"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = module.vpc_primary.sg_ids["${var.sg_pri[5]}"]
}

# Egress Rule
## Common
resource "aws_security_group_rule" "sg-common_egress_ipv4_all" {
  for_each          = toset(var.sg_pri)
  type              = "egress"
  description       = "Allow all outbound traffic by default"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.vpc_primary.sg_ids["${each.value}"]
}
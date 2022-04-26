variable "vpc_pri" {
  description = "Primary VPC Variable."
  default = {
    cidr = "10.0.0.0/16"
    name = "sandbox-vpc"
  }
}

variable "subnet_pri" {
  description = "Primary Subnet Variable. Link to route_table by group name."
  default = [
    { group = "ingress", name = "sandbox-subnet-public-ingress-1a", cidr = "10.0.0.0/24", az = "ap-northeast-1a" },
    { group = "ingress", name = "sandbox-subnet-public-ingress-1c", cidr = "10.0.1.0/24", az = "ap-northeast-1c" },
    { group = "app", name = "sandbox-subnet-private-app-1a", cidr = "10.0.10.0/24", az = "ap-northeast-1a" },
    { group = "app", name = "sandbox-subnet-private-app-1c", cidr = "10.0.11.0/24", az = "ap-northeast-1c" },
    { group = "db", name = "sandbox-subnet-private-db-1a", cidr = "10.0.20.0/24", az = "ap-northeast-1a" },
    { group = "db", name = "sandbox-subnet-private-db-1c", cidr = "10.0.21.0/24", az = "ap-northeast-1c" },
    { group = "bastion", name = "sandbox-subnet-public-bastion-1a", cidr = "10.0.240.0/24", az = "ap-northeast-1a" },
    #{group = "bastion", name = "sandbox-subnet-public-bastion-1c", cidr = "10.0.241.0/24", az = "ap-northeast-1c"},
    { group = "egress", name = "sandbox-subnet-private-egress-1a", cidr = "10.0.248.0/24", az = "ap-northeast-1a" },
    { group = "egress", name = "sandbox-subnet-private-egress-1c", cidr = "10.0.249.0/24", az = "ap-northeast-1c" },
  ]
}

variable "prefix_list_pri" {
  description = "Primary VPC prefix list Variable."
  default = [
    {
      name           = "sandbox-prefix-app-subnet",
      address_family = "IPv4",
      max_entries    = 5,
      entry_list = [
        "sandbox-subnet-private-app-1a",
        "sandbox-subnet-private-app-1c",
        "sandbox-subnet-public-bastion-1a"
      ]
    }
  ]
}

variable "igw_pri" {
  description = "Primary Internet Gateway Variable."
  default = {
    name = "sandbox-igw"
  }
}

variable "route_table_pri" {
  description = "Primary Route Table Variable. Link to subnet by group name."
  default = [
    { group = "ingress", name = "sandbox-routetable-ingress", },
    { group = "app", name = "sandbox-routetable-app" },
    { group = "db", name = "sandbox-routetable-db" },
    { group = "bastion", name = "sandbox-routetable-bastion" },
    { group = "egress", name = "sandbox-routetable-egress" },
  ]
}

variable "sg_pri" {
  description = "Primary Security Group Variable."
  default = [
    "sabdbox-sg-ingress",
    "sabdbox-sg-frontend",
    "sabdbox-sg-internal",
    "sabdbox-sg-backend",
    "sabdbox-sg-db",
    "sabdbox-sg-bastion",
    "sabdbox-sg-egress",
  ]
}

variable "ecr_pri" {
  description = "Primary ECR Variable."
  default = {
    private = [
      { name = "sandbox-frontend", encrypt_type = "AES256", encrypt_key = null, tag_mutable = true },
      { name = "sandbox-backend", encrypt_type = "AES256", encrypt_key = null, tag_mutable = true }
    ]
  }
}

variable "vpc_endpoint_pri" {
  description = "Primary VPC Endpoint Variable."
  default = {
    ecr_api = {
      name         = "sandbox-vpce-ecr-api",
      service_name = "ecr.api",
      type         = "Interface",
      dns          = true
    }
    ecr_dkr = {
      name         = "sandbox-vpce-ecr-dkr",
      service_name = "ecr.dkr",
      type         = "Interface",
      dns          = true
    }
    s3 = {
      name         = "sandbox-vpce-s3",
      service_name = "s3",
      type         = "Gateway",
      dns          = true
    }
    logs = {
      name         = "sandbox-vpce-logs",
      service_name = "logs",
      type         = "Interface",
      dns          = true
    }
    secretsmanager = {
      name         = "sandbox-vpce-sectetsmanager"
      service_name = "secretsmanager"
      type         = "Interface"
      dns          = true
    }
  }
}

variable "lb_pri" {
  description = "Primary LB Variable."
  default = {
    lb = [
      // Backend
      {
        name               = "sandbox-alb-internal"
        internal           = true
        sg_name            = "sabdbox-sg-internal"
        load_balancer_type = "application"
        subnets_name = [
          "sandbox-subnet-private-app-1a",
          "sandbox-subnet-private-app-1c",
        ]
      },
      // Frontend
      {
        name               = "sandbox-alb-ingress"
        internal           = false
        sg_name            = "sabdbox-sg-ingress"
        load_balancer_type = "application"
        subnets_name = [
          "sandbox-subnet-public-ingress-1a",
          "sandbox-subnet-public-ingress-1c",
        ]
      }
    ]
    tg = [
      // Backend
      {
        name     = "sandbox-alb-internal-tg-blue"
        type     = "ip"
        protocol = "HTTP"
        port     = 80
        health_check = {
          path              = "/healthcheck"
          timeout           = 5
          interval          = 15
          healthy_threshold = 3
        }
        listner_http = true
      },
      {
        name     = "sandbox-alb-internal-tg-green"
        type     = "ip"
        protocol = "HTTP"
        port     = 80
        health_check = {
          path              = "/healthcheck"
          timeout           = 5
          interval          = 15
          healthy_threshold = 3
        }
        listner_http = true
      },
      // Frontend
      {
        name     = "sandbox-alb-ingress-tg-blue"
        type     = "ip"
        protocol = "HTTP"
        port     = 80
        health_check = {
          path              = "/healthcheck"
          timeout           = 5
          interval          = 15
          healthy_threshold = 3
        }
        listner_http = true
      }
    ]
    listener = [
      // Backend
      {
        name     = "internal-listener-blue"
        lb_name  = "sandbox-alb-internal"
        port     = "80"
        protocol = "HTTP"
        action = {
          type    = "forward"
          tg_name = "sandbox-alb-internal-tg-blue"
        }
      },
      {
        name     = "internal-listener-green"
        lb_name  = "sandbox-alb-internal"
        port     = "10080"
        protocol = "HTTP"
        action = {
          type    = "forward"
          tg_name = "sandbox-alb-internal-tg-green"
        }
      },
      // Frontend
      {
        name     = "internal-ingress-blue"
        lb_name  = "sandbox-alb-ingress"
        port     = "80"
        protocol = "HTTP"
        action = {
          type    = "forward"
          tg_name = "sandbox-alb-ingress-tg-blue"
        }
      }
    ]
  }
}

variable "ecs_pri" {
  default = {
    task = {
      backend = {
        name           = "sandbox-backend-def"
        cpu            = 512
        memory         = 1024
        tag            = "v1"
        container_name = "backend-app"
      },
      frontend = {
        name           = "sandbox-frontend-def"
        cpu            = 512
        memory         = 1024
        tag            = "dbv1"
        container_name = "frontend-app"
        lb_name        = "sandbox-alb-internal"
      }
    }
    cluster = {
      backend = {
        name = "sandbox-ecs-backend-cluster"
      }
      frontend = {
        name = "sandbox-ecs-frontend-cluster"
      }
    }
    service = {
      backend = {
        name         = "sandbox-ecs-backend-service"
        instance_num = 2
        sg_name      = "sabdbox-sg-backend"
        subnets_name = [
          "sandbox-subnet-private-app-1a",
          "sandbox-subnet-private-app-1c",
        ]
        lb = [
          {
            tg_name = "sandbox-alb-internal-tg-blue"
            port    = 80
          },
          {
            tg_name = "sandbox-alb-internal-tg-green"
            port    = 80
          }
        ]
      }
      frontend = {
        name         = "sandbox-ecs-frontend-service"
        instance_num = 1
        sg_name      = "sabdbox-sg-frontend"
        subnets_name = [
          "sandbox-subnet-private-app-1a",
          "sandbox-subnet-private-app-1c",
        ]
        lb = [
          {
            tg_name = "sandbox-alb-ingress-tg-blue"
            port    = 80
          }
        ]
      }
    }
  }
}

variable "db_pri" {
  default = {
    cluster_identifier = "sandbox-db-cluster"
    engine             = "aurora-mysql"
    engine_version     = "5.7.mysql_aurora.2.10.2"
    az                 = ["ap-northeast-1a", "ap-northeast-1c"]
    db_name            = "sandboxdb"
    bk_retention       = 5
    bk_window          = "07:00-09:00"
    instance_prefix    = "sandbox-db-instance"
    instance_num       = 2
  }
}
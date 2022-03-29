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
    { group = "ingress", name = "sandbox-subnet-public-ingress-1d", cidr = "10.0.2.0/24", az = "ap-northeast-1d" },
    { group = "app", name = "sandbox-subnet-private-app-1a", cidr = "10.0.10.0/24", az = "ap-northeast-1a" },
    { group = "app", name = "sandbox-subnet-private-app-1c", cidr = "10.0.11.0/24", az = "ap-northeast-1c" },
    { group = "app", name = "sandbox-subnet-private-app-1d", cidr = "10.0.12.0/24", az = "ap-northeast-1d" },
    { group = "db", name = "sandbox-subnet-private-db-1a", cidr = "10.0.20.0/24", az = "ap-northeast-1a" },
    { group = "db", name = "sandbox-subnet-private-db-1c", cidr = "10.0.21.0/24", az = "ap-northeast-1c" },
    { group = "db", name = "sandbox-subnet-private-db-1d", cidr = "10.0.22.0/24", az = "ap-northeast-1d" },
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
        "sandbox-subnet-private-app-1d",
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
  }
}
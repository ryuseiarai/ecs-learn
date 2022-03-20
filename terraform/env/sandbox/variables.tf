variable "vpc_pri" {
  description = "Primary VPC Variable."
  default = {
    cidr = "10.0.0.0/16"
    name = "sandbox-vpc01"
  }
}

variable "subnet_pri" {
  description = "Primary Subnet Variable. Link to route_table by group name."
  default = [
    { group = "ingress", name = "sandbox-subnet01-public-ingress-1a", cidr = "10.0.0.0/24", az = "ap-northeast-1a" },
    { group = "ingress", name = "sandbox-subnet01-public-ingress-1c", cidr = "10.0.1.0/24", az = "ap-northeast-1c" },
    { group = "ingress", name = "sandbox-subnet01-public-ingress-1d", cidr = "10.0.2.0/24", az = "ap-northeast-1d" },
    { group = "app", name = "sandbox-subnet01-private-app-1a", cidr = "10.0.10.0/24", az = "ap-northeast-1a" },
    { group = "app", name = "sandbox-subnet01-private-app-1c", cidr = "10.0.11.0/24", az = "ap-northeast-1c" },
    { group = "app", name = "sandbox-subnet01-private-app-1d", cidr = "10.0.12.0/24", az = "ap-northeast-1d" },
    { group = "db", name = "sandbox-subnet01-private-db-1a", cidr = "10.0.20.0/24", az = "ap-northeast-1a" },
    { group = "db", name = "sandbox-subnet01-private-db-1c", cidr = "10.0.21.0/24", az = "ap-northeast-1c" },
    { group = "db", name = "sandbox-subnet01-private-db-1d", cidr = "10.0.22.0/24", az = "ap-northeast-1d" },
    { group = "bastion", name = "sandbox-subnet01-public-bastion-1a", cidr = "10.0.240.0/24", az = "ap-northeast-1a" }
    #{group = "bastion", name = "sandbox-subnet01-public-bastion-1c", cidr = "10.0.241.0/24", az = "ap-northeast-1c"},
  ]
}

variable "igw_pri" {
  description = "Primary Internet Gateway Variable."
  default = {
    name = "sandbox-igw01"
  }
}

variable "route_table_pri" {
  description = "Primary Route Table Variable. Link to subnet by group name."
  default = [
    { group = "ingress", name = "sandbox-routetable01-ingress", },
    { group = "app", name = "sandbox-routetable01-app" },
    { group = "db", name = "sandbox-routetable01-db" },
    { group = "bastion", name = "sandbox-routetable01-baction" },
  ]
}

variable "sg_pri" {
  description = "Primary Security Group Variable."
  default = [
    {
      name = "sabdbox-sg01-ingress",
      eggress = [
        { cidr = "0.0.0.0/0", description = "Allow all outboud traffic", protocol = "-1" }
      ],
      ingress = [
        { cidr = "0.0.0.0/0", description = "from 0.0.0.0/0:80", protocol = "tcp", from_port = "80", to_port = "80" },

      ]
    }
  ]
}

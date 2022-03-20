terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.6.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
  default_tags {
    tags = {
      Env       = "sandbox"
      Service   = "ecs-learn"
      Terraform = "true"
    }
  }
}
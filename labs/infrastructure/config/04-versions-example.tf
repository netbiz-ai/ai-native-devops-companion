terraform {
  required_version = ">= 1.7.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.region
}

module "network" {
  source = "../../modules/network"

  name     = "reference-dev"
  vpc_cidr = "10.42.0.0/16"
  subnets = {
    "us-east-1a" = "10.42.10.0/24"
    "us-east-1b" = "10.42.20.0/24"
  }
  tags = {
    owner       = "platform-team"
    environment = "development"
    project     = "reference-application"
  }
}

variable "region" {
  description = "Approved sandbox region."
  type        = string
}

output "network" {
  description = "Network identifiers for later platform chapters."
  value = {
    vpc_id     = module.network.vpc_id
    subnet_ids = module.network.subnet_ids
  }
}

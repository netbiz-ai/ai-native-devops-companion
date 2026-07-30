module "network" {
  source = "../../modules/network"

  name     = "ai-native-devops-dev"
  vpc_cidr = "10.42.0.0/16"
  subnets = {
    app_a = {
      cidr              = "10.42.10.0/24"
      availability_zone = "${var.aws_region}a"
    }
    app_b = {
      cidr              = "10.42.20.0/24"
      availability_zone = "${var.aws_region}b"
    }
  }
  tags = var.tags
}

output "vpc_id" {
  value = module.network.vpc_id
}

output "subnet_ids" {
  value = module.network.subnet_ids
}

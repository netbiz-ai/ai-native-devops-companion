locals {
  # coalesce skips the empty string, so region wins when it is set and
  # aws_region carries its default otherwise.
  aws_region = coalesce(var.region, var.aws_region)
}

# Setting both to different values is ambiguous, and silently picking one is how
# this went wrong in the first place. Say so instead.
check "region_is_unambiguous" {
  assert {
    condition     = var.region == "" || var.region == var.aws_region || var.aws_region == "us-east-1"
    error_message = "region (${var.region}) and aws_region (${var.aws_region}) are both set and disagree. Set one."
  }
}

module "network" {
  source = "../../modules/network"

  name     = "ai-native-devops-dev"
  vpc_cidr = "10.42.0.0/16"
  subnets = {
    app_a = {
      cidr              = "10.42.10.0/24"
      availability_zone = "${local.aws_region}a"
    }
    app_b = {
      cidr              = "10.42.20.0/24"
      availability_zone = "${local.aws_region}b"
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

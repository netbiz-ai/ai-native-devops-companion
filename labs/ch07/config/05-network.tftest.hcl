mock_provider "aws" {}

run "accepts_distinct_subnets" {
  command = plan

  variables {
    name     = "reference-dev"
    vpc_cidr = "10.42.0.0/16"
    subnets = {
      "zone-a" = "10.42.10.0/24"
      "zone-b" = "10.42.20.0/24"
    }
    tags = {
      owner       = "platform-team"
      environment = "development"
      project     = "reference-application"
    }
  }
}

run "rejects_duplicate_subnets" {
  command = plan

  variables {
    name     = "reference-dev"
    vpc_cidr = "10.42.0.0/16"
    subnets = {
      "zone-a" = "10.42.10.0/24"
      "zone-b" = "10.42.10.0/24"
    }
    tags = {
      owner       = "platform-team"
      environment = "development"
      project     = "reference-application"
    }
  }

  expect_failures = [var.subnets]
}

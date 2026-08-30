variable "name" {
  description = "Base name for network resources."
  type        = string

  validation {
    condition     = length(trimspace(var.name)) >= 3
    error_message = "name must contain at least three characters."
  }
}

variable "vpc_cidr" {
  description = "Approved IPv4 CIDR for the virtual network."
  type        = string

  validation {
    condition     = can(cidrnetmask(var.vpc_cidr))
    error_message = "vpc_cidr must be a valid IPv4 CIDR."
  }
}

variable "subnets" {
  description = "Map of availability zone names to approved IPv4 CIDRs."
  type        = map(string)

  validation {
    condition = (
      length(var.subnets) == 2 &&
      length(distinct(values(var.subnets))) == 2 &&
      alltrue([for cidr in values(var.subnets) : can(cidrnetmask(cidr))])
    )
    error_message = "Provide two distinct, valid IPv4 subnet CIDRs."
  }
}

variable "tags" {
  description = "Ownership and classification tags applied to every resource."
  type        = map(string)

  validation {
    condition = alltrue([
      for key in ["owner", "environment", "project"] :
      try(trimspace(var.tags[key]) != "", false)
    ])
    error_message = "tags must include non-empty owner, environment, and project values."
  }
}

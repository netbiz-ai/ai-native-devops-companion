variable "name" {
  description = "Name prefix for the network."
  type        = string

  validation {
    condition     = length(trimspace(var.name)) >= 3
    error_message = "name must contain at least three characters."
  }
}

variable "vpc_cidr" {
  description = "Private IPv4 CIDR for the VPC."
  type        = string

  validation {
    condition     = can(cidrnetmask(var.vpc_cidr))
    error_message = "vpc_cidr must be a valid IPv4 CIDR."
  }
}

variable "subnets" {
  description = "Subnet name to CIDR and availability-zone mapping."
  type = map(object({
    cidr              = string
    availability_zone = string
  }))

  validation {
    condition     = length(var.subnets) == 2
    error_message = "The teaching module requires exactly two subnets."
  }
}

variable "tags" {
  description = "Required ownership and lifecycle tags."
  type        = map(string)

  validation {
    condition = alltrue([
      for key in ["Owner", "Environment", "ExpiresAt"] :
      contains(keys(var.tags), key) && trimspace(var.tags[key]) != ""
    ])
    error_message = "tags must include non-empty Owner, Environment, and ExpiresAt values."
  }
}

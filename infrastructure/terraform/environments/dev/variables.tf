variable "aws_region" {
  description = "Approved sandbox region."
  type        = string
  default     = "us-east-1"
}

# The chapter prints `export TF_VAR_region="$APPROVED_AWS_REGION"`, and this
# module declared only aws_region. Terraform does not warn about an undeclared
# TF_VAR_* environment variable the way it does about an undeclared -var, so
# labs/infrastructure/04-create-plan.sh printed "Target account assertion passed for
# us-east-2" and then planned us-east-1 with nothing to contradict it. The
# account was asserted and the region was not.
#
# Declaring the printed name makes that command mean what it says. aws_region
# stays the module's own name and its default, so nothing that already sets it
# changes behaviour.
variable "region" {
  description = "Alias for aws_region, under the name Chapter 7 prints. Wins when set."
  type        = string
  default     = ""
}

variable "tags" {
  description = "Ownership and expiry tags."
  type        = map(string)
  default = {
    Owner       = "REPLACE_ME"
    Environment = "dev"
    ExpiresAt   = "REPLACE_ME"
  }
}

variable "aws_region" {
  description = "Approved sandbox region."
  type        = string
  default     = "us-east-1"
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

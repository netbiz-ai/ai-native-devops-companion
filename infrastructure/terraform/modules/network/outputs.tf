output "vpc_id" {
  description = "Created VPC identifier."
  value       = aws_vpc.this.id
}

output "subnet_ids" {
  description = "Subnet name to identifier mapping."
  value       = { for name, subnet in aws_subnet.this : name => subnet.id }
}

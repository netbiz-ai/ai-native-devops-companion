output "vpc_id" {
  description = "Identifier of the created virtual network."
  value       = aws_vpc.this.id
}

output "subnet_ids" {
  description = "Subnet identifiers keyed by availability zone."
  value       = { for zone, subnet in aws_subnet.this : zone => subnet.id }
}

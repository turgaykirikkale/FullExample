output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.vpc.id
}

output "name" {
  description = "Name of the VPC"
  value = var.vpc_name
}

output "vpc_cidr_block" {
  description = "The ID of the VPC"
  value       = aws_vpc.vpc.cidr_block
}
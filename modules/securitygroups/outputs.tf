output "sg_id" {
  description = "The ID of the security group"
  value       = aws_security_group.security_group.id
}
output "cidr_block" {
  description = "the CIDR block of the security group"
  value       = aws_security_group.security_group.ingress[*].cidr_blocks
}

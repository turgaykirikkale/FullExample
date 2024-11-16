# Output: Hosted Zone Name
output "hosted_zone_name" {
  value       = aws_route53_zone.teggies.name
  description = "The name of the Hosted Zone."
}

# Output: Name Servers (NS Records)
output "name_servers" {
  value       = aws_route53_zone.teggies.name_servers
  description = "The name servers associated with the Hosted Zone."
}

output "db_instance_endpoint" {
  description = "RDS instance endpoint"
  value       = aws_db_instance.db.endpoint
}

output "db_instance_arn" {
  description = "RDS instance ARN"
  value       = aws_db_instance.db.arn
}
output "read_replica_endpoints" {
  description = "Replicas endpoints"
  value       = [for replica in aws_db_instance.read_replica : replica.endpoint]
}

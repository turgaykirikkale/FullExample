output "redis_cluster_id" {
  description = "The ID of the Redis cluster"
  value       = aws_elasticache_cluster.elasticache.id
}
output "redis_port" {
  description = "The port number of the Redis cluster"
  value       = aws_elasticache_cluster.elasticache.port
}

output "redis_cluster_arn" {
  description = "The ARN of the Redis cluster"
  value       = aws_elasticache_cluster.elasticache.arn
}
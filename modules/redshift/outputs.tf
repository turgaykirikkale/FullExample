output "redshift_endpoint" {
  value = aws_redshift_cluster.this.endpoint
}

output "redshift_cluster_id" {
  value = aws_redshift_cluster.this.cluster_identifier
}

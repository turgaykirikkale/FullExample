# Aurora Cluster ARN
output "aurora_cluster_arn" {
  value = aws_rds_cluster.aurora.arn
}

# Aurora Instance ARN'leri (writer ve reader)
output "aurora_writer_instance_arn" {
  value = aws_rds_cluster_instance.aurora_instance_writer.arn

}

output "aurora_reader_instance_arn" {
  value = [for instance in aws_rds_cluster_instance.aurora_instance_reader : instance.arn]

}

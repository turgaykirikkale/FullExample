output "cluster_id" {
  value = aws_eks_cluster.this.id
}

output "cluster_endpoint" {
  value = aws_eks_cluster.this.endpoint
}

output "node_group_name" {
  value = aws_eks_node_group.this.node_group_name
}

output "ebs_id" {
  value = aws_ebs_volume.ebs.id
}

output "ebs_name" {
  value = var.volume_name
}

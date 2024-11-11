output "snapshot_id" {
  description = "ID of the created snapshot"
  value       = aws_ebs_snapshot.snapshot.id
}

output "restored_volume_id" {
  description = "ID of the restored EBS volume from snapshot"
  value       = aws_ebs_volume.restored_volume[0].id
}

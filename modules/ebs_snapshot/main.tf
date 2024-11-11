resource "aws_ebs_snapshot" "snapshot" {
  volume_id   = var.volume_id
  description = var.description
  tags = {
    Name = var.snapshot_name
  }
}


//if we want to create new ebs volume from snapshot we could use here
resource "aws_ebs_volume" "restored_volume" {
  count             = var.create_volume_from_snapshot ? 1 : 0
  availability_zone = var.availability_zone
  snapshot_id       = aws_ebs_snapshot.snapshot.id
  size              = var.size
  encrypted         = var.encrypted
  tags = {
    Name = var.snapshot_name
  }
}




/*
EBS (Elastic Block Store) Snapshots are a service in AWS used to back up EBS volumes by creating point-in-time copies stored in durable storage, 
like Amazon S3. Snapshots enhance data security, enable disaster recovery, and allow you to replicate configurations across regions or instances quickly.

### Benefits:
1. **Data Backup:** Snapshots provide a reliable way to back up EBS data at a specific moment.
2. **Fast Recovery:** Snapshots allow quick restoration in case of data loss or failure.
3. **Regional Cloning:** Snapshots can be copied across regions, aiding multi-region deployments and redundancy.
4. **Time and Cost Savings:** Incremental snapshots only store changes since the last backup, reducing storage costs.
5. **Automated Snapshot Plans:** Regular snapshots can be automated using services like AWS Backup.

### Drawbacks and Limitations:
1. **Cost:** Storage costs may increase if snapshots are taken frequently.
2. **Snapshot Time:** The first snapshot takes longer as it copies all data; incremental snapshots reduce time but can still be lengthy for large volumes.
3. **Data Inconsistencies:** Active write operations during a snapshot can lead to inconsistencies; freezing volumes or verifying data afterward is recommended.
4. **Restore Time:** Restoration from a snapshot can be slow, depending on data size.

### EBS Snapshot Features:
- **Incremental Backups:** The initial snapshot saves all data; subsequent snapshots save only changes.
- **Cross-Region Copy:** Snapshots can be replicated to other AWS regions.
- **Cross-Account Sharing:** Snapshots can be shared with other AWS accounts, useful for collaborative projects.
- **Lifecycle Management:** Snapshots can be managed automatically, such as with automated deletions of old snapshots.
- **Encryption:** Snapshots support encryption, and encrypted snapshots restore as encrypted volumes.
- **Fast Snapshot Restore (FSR):** Available in some regions, FSR speeds up restoration from snapshots.

*/

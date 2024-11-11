resource "aws_ebs_volume" "ebs" {
  availability_zone = var.availability_zone
  size              = var.volume_size

  tags = {
    Name = var.volume_name
  }
}

/*
EBS (Elastic Block Store) is a storage service provided by Amazon Web Services (AWS) that offers persistent block storage for virtual servers running on Amazon EC2 (Elastic Compute Cloud). This storage works like virtual disks and is designed to ensure data persistence. Even if the servers are shut down, data stored on EBS remains intact and can be accessed again when needed.

The key features of EBS include:

1. **Persistent Storage**: Data is retained on EBS even if the virtual servers to which it is attached are shut down. 
    This feature ensures data security and continuous accessibility.
2. **Scalability**: EBS volumes can be easily scaled up. You can create larger volumes based on your capacity and performance requirements.
3. **Snapshot Functionality**: EBS allows snapshots to be taken for backing up volumes. 
    These snapshots are stored on Amazon S3 and can be used to create a new EBS volume when needed.
4. **Performance Tiers**: EBS offers a variety of storage options tailored to different performance needs. 
    For example, you can choose between high-performance SSD-based storage (IOPS), general-purpose SSD (GP), or magnetic storage.
5. **Durability and Security**: EBS automatically replicates data across multiple availability zones, enhancing durability. It also offers encryption options to ensure data security.

EBS is ideal for applications where data security is crucial and long-term storage is required.

An EBS volume can only be attached to one EC2 instance at a time, meaning it can directly connect to a single EC2 instance and operate with it. 
    This limitation is in place to ensure data integrity and maintain a consistent file system.

However, there are alternative solutions for sharing the same data with multiple EC2 instances in specific scenarios:

1. **Amazon EFS (Elastic File System)**: EFS provides a shared file system accessible by multiple EC2 instances simultaneously. 
   It’s ideal when many EC2 instances need access to the same files and offers file-level sharing.

2. **EBS Multi-Attach (for Provisioned IOPS SSD - io1 and io2 only)**: Some types of EBS volumes (specifically Provisioned IOPS SSD - io1 and io2) support *Multi-Attach*, 
    allowing the same EBS volume to be attached to multiple EC2 instances simultaneously. This feature is designed for certain performance and consistency requirements but is not available in all AWS regions or on every type of EBS volume.

3. **Data Synchronization or Backups**: Using EBS snapshots or third-party data synchronization tools, data can be shared or copied across different EC2 instances. 
    This method is often used to enhance data redundancy or enable data sharing.

4. **Amazon FSx**: For high-performance file sharing, Amazon FSx (particularly FSx for Windows File Server or FSx for Lustre) is suitable for applications requiring data sharing with multiple EC2 instances.

In summary, the same EBS volume can only be attached to one EC2 instance at a time, but data can be shared or synchronized with multiple EC2 instances using the methods listed above.

EBS volumes can be attached in the same AZ we cant use it different AZ.

delete_on_termination = false EBS volume will not be deleted. After EC2 is terminated.


| Volume Type | Performance                    | Typical Use Cases                          |
|-------------|------------------------------  |--------------------------------------------|
| gp2         | General Purpose SSD            | General workloads, databases               |
| gp3         | Adjustable General Purpose SSD | General workloads, software applications   |
| io1         | High IOPS, low latency         | Intensive databases, critical applications |
| io2         | Durable and high IOPS          | Enterprise databases, critical workloads   |
| st1         | High-throughput HDD            | Big data, data warehouses                  |
| sc1         | Low-cost HDD                   | Infrequent access, archive                 |
| Magnetic    | Legacy HDD type                | Backup, archive                            |

*/

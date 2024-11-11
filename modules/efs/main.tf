resource "aws_efs_file_system" "efs" {
  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS" # Optional: transition to Infrequent Access after 30 days
  }
  performance_mode = "generalPurpose" # "maxIO" is another option for high-throughput use cases
  throughput_mode  = "bursting"       # "provisioned" is an option if you want a fixed throughput
}

resource "aws_efs_mount_target" "efs_mount_target" {
  count           = length(var.subnet_ids)
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = var.subnet_ids[count.index]
  security_groups = [var.security_group_id]
}

/*
EFS (Elastic File System) is a file storage service offered by AWS (Amazon Web Services). 
AWS EFS provides flexibility and easy scalability as a cloud-based file system and is ideal for scenarios where simultaneous access from multiple sources is required.
 EFS allows you to create a shared file system that can be accessed by Amazon EC2 instances or other services across multiple regions or Availability Zones.

Here are some key features of EFS:

1. **Fully Managed File System**: AWS fully manages EFS, which means server management, data backup, fault tolerance, and scaling are all handled by AWS.
2. **Automatic Scaling**: EFS automatically scales according to data demand; capacity increases as more data is added and decreases when data is removed.
3. **High Performance and Low Latency**: EFS provides high-speed data access with low latency.
4. **NFS Support**: EFS uses the NFS (Network File System) protocol and is compatible with NFSv4, making integration with Linux and other NFS-supported systems straightforward.
5. **Multi-Access**: Multiple EC2 instances can connect to an EFS file system simultaneously and access data concurrently, which is especially useful in distributed applications.
6. **Data Durability and Availability**: EFS enhances durability by distributing data across different Availability Zones.

EFS is commonly used for applications that require high data sharing, big data processing, content management, and web servers.


EFS (Elastic File System) is a file storage solution that provides high performance and flexibility. In terms of performance, EFS offers two different performance modes:

### 1. Bursting Performance Mode
   - This mode is ideal for applications with irregular or variable I/O (Input/Output) operations.
   - When your file system is small, it operates at a limited baseline speed, but as the file system grows, EFS automatically provides higher performance.
   - EFS generates a burst credit based on the size of the file system. This credit is used in moments of high I/O demands, providing short-term high performance.
   - In burst mode, EFS can offer up to 50 MB/s of performance per GB, so as your file system grows, the maximum speed increases.

### 2. Provisioned Performance Mode
   - Provisioned Performance Mode is used when your application requires a stable and high IOPS (Input/Output Operations Per Second) performance.
   - This mode allows you to set a specific performance level, regardless of the file system's size.
   - Users can adjust a specific throughput (MB/s) based on their needs, making it an ideal solution for workloads with heavy I/O requirements.
   - Unlike the automatically scaled throughput in EFS, provisioned throughput is not limited by a lower speed per GB, though it incurs additional costs to reach the set performance level.

### EFS Throughput Tiers
EFS provides two throughput tiers to offer more economical or higher performance options:

- **Standard**: By default, all file systems are created in this tier. It is suitable for frequently accessed files that require high performance.
- **Infrequent Access (IA)**: A low-cost option used for data that is accessed less frequently, providing a cost advantage while allowing lower access frequency.

### General Performance Features
- **Low Latency**: EFS provides low-latency data access (at the millisecond level), enabling high-speed data read/write operations.
- **Parallel Processing Support**: Multiple EC2 instances can access the EFS file system simultaneously. This parallel access is ideal for workloads that require high performance.

These performance features make EFS suitable for big data processing, analytics, and applications requiring high accessibility and scalability.

EFS (Elastic File System) is a flexible and scalable file storage service offered by AWS. EFS is particularly suitable for workloads that require multi-access, providing a file system on the cloud that automatically scales and offers high availability and durability. Here is an overview of EFS storage features:

### 1. **Automatic Scalability**
   - EFS automatically adjusts storage space according to your data; capacity increases as data is added and decreases when data is deleted.
   - It scales on demand without needing to set minimum or maximum capacity, allowing it to handle sudden increases in traffic or data requirements.

### 2. **Storage Tiers (Throughput Tiers)**
   - **Standard**: This tier offers high performance for more frequently accessed data. By default, all file systems are created in this tier.
   - **Infrequent Access (IA)**: This lower-cost option is suitable for data that is accessed less frequently. The IA tier provides a cost advantage for storing data that doesn't require regular access.
   - **Lifecycle Management**: EFS can automatically move data from the Standard tier to the IA tier if it hasn't been accessed for a specified period. By default, this period is set to 30 days but can be customized by the user.

### 3. **High Durability and Availability**
   - EFS replicates your data across multiple Availability Zones (AZs) in the same region to maintain high durability, reducing the risk of data loss or access disruption.
   - For data durability, data is automatically backed up, allowing access from other zones even if there is a regional outage.

### 4. **Multiple EC2 Access**
   - EFS supports simultaneous access from multiple Amazon EC2 instances to the same file system. This feature is beneficial for applications that require files to be accessible from many sources, such as web servers, big data processing, and content management systems.
   - EFS is compatible with the NFSv4 protocol, facilitating integration with Linux and other Unix-based systems.

### 5. **Backup and Security**
   - With EFS Backup, you can create regular snapshots of your file system. EFS Backup integrates with Amazon Backup.
   - EFS provides access control by user and role, as well as network-based security with Amazon VPC (Virtual Private Cloud) integration and IAM (Identity and Access Management) permissions to secure file system access.
   - Data can be encrypted both in transit and at rest.

### 6. **Cost Management**
   - EFS can offer lower-cost storage by using the automatically managed IA (Infrequent Access) tier.
   - Using the IA tier allows you to optimize costs by storing infrequently accessed data at a lower price.
   - With AWS lifecycle policies, data that hasn’t been accessed for a specified time will automatically move to the IA tier, providing a cost advantage.

EFS provides a flexible, secure, and durable solution for workloads that require data storage and sharing. Particularly in cloud-based applications, EFS meets users' data management needs by offering high performance and scalability.


EFS (Elastic File System) costs can be reduced through several strategies, enabling you to minimize unnecessary expenses while maintaining the storage and performance you need:

### 1. **Use the Infrequent Access (IA) Storage Tier**
   - The **Infrequent Access (IA)** tier is designed for data that isn’t frequently accessed and offers a significantly lower cost. If your data doesn't require constant access, using IA can reduce expenses.
   - **Lifecycle Management**: Enable EFS lifecycle policies to automatically move data that hasn't been accessed for a certain period to the IA tier. By default, data moves to IA if it hasn’t been accessed in 30 days, but you can adjust this period.

### 2. **Segment Your File System**
   - Separate your data into different file systems based on access frequency and performance needs. Frequently accessed, high-performance data can stay in the **Standard** tier, while rarely accessed data is stored in the IA tier.
   - Segmenting data ensures you’re only paying for high performance where needed, optimizing costs.

### 3. **Review Data Retention Periods**
   - Regularly review and clean up unnecessary or outdated files to reduce your overall storage footprint.
   - Use automated workflows to identify and remove old data or transfer it to a more cost-effective storage solution, such as S3 Glacier, if long-term retention is required.

### 4. **Optimize Provisioned Throughput Settings**
   - If you’re using **Provisioned Throughput**, review and adjust the settings to match your needs, as this option incurs additional costs.
   - Set throughput based on actual requirements and avoid unnecessary high settings when your workload doesn’t demand it.

### 5. **Leverage EFS Storage Discounts**
   - AWS offers special pricing options for customers with large data storage needs. This can be especially beneficial for organizations that consistently store large amounts of data.
   - Contact AWS sales to explore discounted pricing based on your storage volumes.

By implementing these cost-saving measures, you can reduce EFS costs while maintaining adequate performance and availability for your workloads.


Here’s the information translated into English:

---

When connecting **EFS (Elastic File System)** and **EC2 instances**, assigning them to the correct **subnets** can create a critical difference in terms of connectivity. This distinction relates to **EFS mount targets** and the **subnets** where the EC2 instances will be placed. There are two main cases regarding subnet assignments:

### 1. **EFS Mount Targets and Subnets**
EFS creates one **mount target** per **availability zone (AZ)**. These mount targets are necessary for EC2 instances to connect to the EFS file system.

- **Mount Target Subnets**: EFS creates a mount target in a specific subnet for each AZ, allowing EC2 instances within that subnet or with access to that subnet to connect to EFS.
  
- **Assigning EFS Mount Targets to Subnets**: Each mount target must run in a designated subnet. If your EC2 instance is in a subnet that doesn’t have access to an EFS mount target, it won’t be able to mount the EFS file system.

#### Example:
- If you create an **EFS mount target** in `subnet-1`, then **only EC2 instances in subnet-1** can directly access this mount target.
- If you create an **EFS mount target** in `subnet-2`, then **only EC2 instances in subnet-2** can access this mount target.

### 2. **Assigning EC2 Instances to Subnets**
While EC2 instances can be placed in any subnet, they need to have access to the EFS mount targets to connect to EFS. However, EC2 instances **do not have to be in the same subnet as the EFS mount target**, as long as **the EFS mount target is accessible to them**.

#### Example:
- If your EC2 instance is in **subnet-1** and the EFS mount target is in **subnet-2**, the EC2 instance can still connect to the EFS mount target in subnet-2, provided the security groups and network configurations are properly set to allow access (port permissions for EFS must be configured).

### In Summary:
- **Mount Target Subnet**: The EFS mount target is created in a specific subnet and can only be accessed by EC2 instances in that subnet. For full availability in each AZ, you need to place a mount target in each AZ’s subnet.
  
- **EC2 Instance Subnet**: EC2 instances can be located in any subnet, as long as they have network access to EFS mount targets (correct security group and network permissions are necessary).

### Differences:
- **Does the EFS mount target need to be in the same subnet as the EC2 instance?**
  - **No**. The EC2 instance and the EFS mount target can be in different subnets, but in this case, security groups and network configurations must be correctly set. 
  - Only proper **network access (routing and security group settings)** between the EC2 instance and the EFS mount target is required.
  
### Quick Tips for EC2 and EFS Connection:
- EC2 instances and EFS must be within the same **VPC** to communicate.
- EC2 instances must have permission to access the **subnets containing the EFS mount targets**.
- Having EFS mount targets in **different subnets** enhances EFS **scalability**, but it requires the appropriate security group and network settings for access.

Choosing the correct subnets and setting up network configurations correctly is critical for establishing communication between the EFS file system and EC2 instances.
*/

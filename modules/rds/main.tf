resource "aws_db_instance" "db" {
  engine              = var.engine
  engine_version      = var.engine_version
  instance_class      = var.instance_class
  db_name             = var.db_name
  username            = var.username
  password            = var.password
  allocated_storage   = var.allocated_storage
  multi_az            = var.multi_Az
  publicly_accessible = var.publicly_accessible
  skip_final_snapshot = var.skip_final_snapshot
  // parameter_group_name = var.parameter_group_name
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = var.security_group_id

  tags = {
    Name = var.name
  }
}

resource "aws_db_instance" "read_replica" {
  count                  = var.replica_count
  replicate_source_db    = aws_db_instance.db.id # Ana veritabanına bağlanır
  instance_class         = var.replica_instance_class
  publicly_accessible    = var.publicly_accessible
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = var.security_group_id


  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.name}-replica-${count.index + 1}"
  }
}


resource "aws_db_subnet_group" "db_subnet_group" {
  name       = var.db_subnet_group_name
  subnet_ids = var.subnet_ids

  tags = {
    Name = var.db_subnet_group_name
  }
}




/*
RDS (Relational Database Service) is a service provided by Amazon Web Services (AWS) that allows users to manage relational databases in a cloud environment. 
RDS automates tasks like setting up, configuring, updating, and backing up database infrastructure on AWS, reducing operational workload. 
It supports popular database engines such as MySQL, PostgreSQL, MariaDB, Oracle, and SQL Server.

AWS RDS offers database performance, scalability, and security features. For example:

- **High Availability and Backup:** RDS provides automatic daily backups and multi-region replication to ensure that the database remains accessible and secure at all times.
- **Automatic Scalability:** CPU, memory, and storage capacity can be increased according to demand.
- **Easy Management:** It can be managed easily through the AWS Management Console, CLI, or APIs.

AWS RDS is ideal for applications that require high-performance and scalable relational database solutions.


Using Amazon RDS instead of deploying a database on an EC2 instance offers several advantages in terms of management, scalability, and reliability. Here are some key benefits:

1. **Automated Management**: RDS automates routine database management tasks like backups, patching, and updates. 
This reduces administrative overhead, while deploying a database on EC2 requires manual setup and maintenance for backups, updates, and patches.

2. **High Availability & Failover**: RDS supports Multi-AZ deployments for high availability and automated failover in case of an outage. 
For databases on EC2, you would need to set up and manage your own replication and failover mechanisms, which can be complex and error-prone.

3. **Automated Backups & Point-in-Time Recovery**: RDS offers automatic daily backups and point-in-time recovery as built-in features. 
On EC2, backups need to be manually configured and managed, and point-in-time recovery is more challenging to implement.

4. **Scalability**: RDS supports easy vertical and horizontal scaling, allowing you to resize compute and storage capacity with minimal downtime. 
On EC2, scaling up or out typically requires manual intervention and may involve provisioning additional instances and configuring load balancing.

5. **Security**: RDS integrates with AWS Identity and Access Management (IAM) for access control, offers encryption at rest and in transit, and supports network isolation through VPCs. 
With an EC2-hosted database, these security configurations need to be set up and managed manually.

6. **Automatic Monitoring and Alerts**: RDS comes with CloudWatch metrics and pre-configured alerts to monitor database health and performance. 
On EC2, setting up monitoring requires manual configuration, including installing and configuring CloudWatch agents.

7. **Cost-Effectiveness**: While there may be situations where an EC2-hosted database is cheaper, 
RDS often provides cost advantages by reducing the operational burden. With RDS, you pay for managed services like backups and failover support, 
which would incur additional costs if done manually on EC2.

8. **Compliance**: RDS is compliant with various industry standards (e.g., HIPAA, SOC, GDPR), 
which can be beneficial if you’re in a regulated industry. Configuring an EC2-hosted database to meet these compliance standards would require additional effort and expertise.

In summary, RDS significantly reduces the operational workload, simplifies scaling, and enhances reliability and security, making it an attractive choice for many use cases. 
Deploying on EC2, however, may still be preferred in cases where highly customized database configurations or specific legacy requirements are needed.


----

While Amazon RDS offers many advantages, it also has some limitations that may impact specific use cases. 
Here are some of the main disadvantages of using RDS:

1. **Limited Customization**: RDS is a managed service, so you have limited control over the underlying infrastructure and certain configurations. 
Advanced configurations, such as specific OS-level customizations, access to the database's underlying file system, or complex replication setups, are not possible. 
For such customizations, running a database on EC2 may be better suited.

2. **Higher Cost for Small Databases**: For small or lightweight databases, the cost of RDS may be higher than deploying on EC2, particularly if you don’t need features like automated backups or high availability. 
EC2 instances, especially the smaller and spot instances, can be a cheaper alternative for simple database needs.

3. **Resource Limitations**: RDS instances have specific resource limitations that might not meet the needs of very large or resource-intensive workloads. If you need high I/O throughput or specialized hardware, such as GPU support, 
RDS may not provide the resources required.

4. **Less Flexibility with Backups and Restores**: RDS automates backups and recovery, but it may not offer the granularity or flexibility some users need. 
For example, cross-account or cross-region backups are not always straightforward, and manual intervention is required to manage complex backup scenarios.

5. **No Direct Access to the Database Server**: RDS restricts access to the underlying server, so tasks like installing custom software, using specialized storage engines, or accessing the file system are not possible. 
This may limit flexibility for certain applications that require custom binaries, server-side scripts, or non-standard database engines.

6. **Upgrade Constraints**: With RDS, AWS manages upgrades and patches, which can sometimes lead to unexpected downtime or compatibility issues. 
Though you can defer some updates, ultimately you have less control over the timing compared to a self-managed database on EC2.

7. **Limited Support for Legacy or Niche Database Engines**: RDS supports popular relational database engines (e.g., MySQL, PostgreSQL, Oracle, SQL Server), but if your application requires a niche or legacy database system, RDS might not be compatible.

8. **Network Latency**: Since RDS is an isolated managed service, connecting it to applications in different regions or availability zones may incur higher network latency and additional data transfer costs, especially for data-intensive applications.

9. **Dependency on AWS Ecosystem**: RDS is tightly integrated with the AWS ecosystem, which can create lock-in. 
Migrating an RDS database to another cloud provider or on-premises setup can be more complex and may involve data transfer fees, configuration adjustments, and downtime.

10. **Billing Complexity**: RDS pricing involves various cost factors, including instance size, storage type, backups, and data transfer. 
This can make costs difficult to predict, especially when scaling up or using advanced features like Multi-AZ deployments or read replicas.

In summary, RDS is highly beneficial for general database needs, but for scenarios requiring advanced customization, extreme performance, cost-efficiency for lightweight workloads, or flexibility with backups and upgrades, deploying on EC2 or another solution may be more advantageous.


------
RDS Storage Autoscaling is an Amazon RDS feature that automatically increases the database storage capacity as needed. 
With this feature, an RDS database's storage capacity expands without requiring manual intervention when it reaches a specified usage threshold, 
ensuring uninterrupted operation in the face of sudden or unexpected data growth.

### Features and Benefits of RDS Storage Autoscaling
- **Automatic Storage Expansion**: Storage is automatically increased when preset thresholds are reached, preventing performance issues or capacity shortages.
- **Minimal Downtime**: The system continues to operate with minimal downtime while the storage capacity is expanded.
- **Cost Efficiency**: Since storage increases only when needed, it avoids the cost of paying for excess storage capacity.
- **Flexible Scalability**: As storage grows, sufficient space is provided to handle increased database load.

### How It Works
1. **Define Initial and Maximum Capacity**: When setting up RDS, an initial storage capacity is defined, along with an optional maximum capacity.
2. **Capacity Threshold Monitoring**: When storage usage approaches a certain percentage threshold (e.g., 90%), the system automatically increases the capacity.
3. **Dynamic Expansion**: Capacity increases gradually based on the system’s defined capacity limits and the demand for storage.

This feature is particularly useful for applications with unpredictable growth rates or variable data loads. 
RDS Storage Autoscaling provides users with a flexible and scalable database experience, maintaining performance as storage demands increase.


-----
RDS Read Replicas is a feature in Amazon RDS designed to improve performance by distributing read loads across multiple copies of a database. 
By creating one or more copies (read replicas) of an RDS database, read operations can be directed to these replicas, reducing the load on the primary database. 
This feature is particularly useful for optimizing database performance in read-heavy applications.

### Features and Benefits of RDS Read Replicas
1. **Load Balancing**: Read-intensive operations (SELECT queries) are directed to read replicas, reducing the load on the primary database and enhancing query performance.
2. **Automatic Synchronization**: Read replicas automatically receive updates from the primary database to keep data current. 
This synchronization is asynchronous, meaning the replica is not updated in real time but has a minimal replication lag.
3. **High Scalability**: Multiple read replicas can be created and distributed across different regions, reducing latency for users from various geographic locations.
4. **Backup and Disaster Recovery**: Read replicas can act as backups or alternatives to the primary database in disaster recovery scenarios, contributing to high availability.

### How It Works
- **Connection with Primary Database**: Read replicas are connected to the primary database, and changes in the primary database are asynchronously propagated to the replicas.
- **Read-Only Access**: Read replicas are intended for read operations only. Write operations (INSERT, UPDATE, DELETE) must be performed on the primary database.
- **Replication Lag**: Since synchronization is asynchronous, there may be a slight delay between the primary database and the replica.

RDS Read Replicas are ideal for applications requiring high read capacity or global access. They improve application performance by offloading tasks like data analysis and reporting to read replicas, 
keeping the primary database focused on write operations.

Summary of Costs:
Same Region Replication: No data transfer cost for replication.
Cross-Region Replication: Data transfer charges apply for replication between regions.
Client Access: No extra cost for accessing replicas within the same region, but inter-region access incurs data transfer fees.
Public Access: Outbound internet traffic incurs standard AWS data transfer charges.
Snapshots: Snapshot storage and inter-region snapshot transfer can incur costs.
Cost Example:
Same region: No additional network costs for replication traffic.
Different region: If your primary database is in the US East (N. Virginia) region, and your Read Replica is in the EU (Ireland) region, you will incur inter-region data transfer costs, which depend on the specific regions involved.
To get a precise estimate of these costs, you can use the AWS Pricing Calculator and review the pricing details for data transfer and snapshots.


---

RDS Multi-AZ (Multi-Availability Zone) is a feature provided by Amazon RDS (Relational Database Service) to ensure high availability and disaster recovery. 
With Multi-AZ, Amazon RDS automatically creates a standby copy of your primary database in a different Availability Zone (AZ) within the same region. 
This increases the reliability of your database and ensures uninterrupted service in case the primary database fails.

### Key Features and Benefits of RDS Multi-AZ:
1. **Automatic Failover**: If the primary database becomes unavailable (e.g., due to hardware failure, network issues, or maintenance), 
RDS automatically switches to the standby database. This transition is nearly seamless for the application, resulting in minimal downtime.
   
2. **Synchronous Replication**: Data from the primary database is synchronously replicated to the standby database, ensuring that both databases are always up-to-date. 
Write operations on the primary database are immediately reflected in the standby database.

3. **High Availability**: The Multi-AZ setup ensures high availability by automatically switching to the standby database in case of issues with the primary database in one AZ, 
ensuring continuous access to the database without interruptions.

4. **Automatic Backups and Maintenance**: Multi-AZ configuration enables automatic backups, software updates, and other maintenance tasks without affecting the availability of the database. 
The standby database is continuously updated along with the primary one, ensuring minimal disruption during maintenance.

### Use Cases:
- **Disaster Recovery**: If the primary database fails for any reason, Multi-AZ ensures that your database automatically switches to the standby database, providing continuity of service.
- **High Availability Requirements**: For critical applications, ensuring continuous database access and minimizing downtime during failures is essential.

RDS Multi-AZ provides a critical feature for ensuring high availability and reliability of your database, offering significant advantages in disaster recovery scenarios.

Amazon RDS Multi-AZ and Read Replicas are two separate features and cannot be used together in the same context. 
Multi-AZ automatically creates a standby database to ensure high availability in case the primary database fails, 
while Read Replicas are used to offload read-heavy workloads by creating copies of the primary database for read operations.

### Differences:
- **Multi-AZ**: The standby database is synchronously updated with the primary database and provides automatic failover in case of failure. 
This feature ensures high availability for your database.
- **Read Replicas**: These are used solely for read operations and are asynchronously synchronized with the primary database. 
This feature helps to improve performance for read-heavy applications.

However, an RDS database can be configured for Multi-AZ for high availability and also have Read Replicas for load balancing read operations. 
This means your database can use Multi-AZ for high availability and also have Read Replicas to offload read traffic, 
but the standby database created by Multi-AZ is only used for failover purposes and cannot be used for reading operations.

### In Summary:
- Multi-AZ ensures high availability with automatic failover.
- Read Replicas are used to distribute read-heavy workloads.
Both features can be used together on a database, but the standby database in Multi-AZ is used only for failover and cannot handle read operations.

Summary of Multi-AZ Network Costs:
Replication between Primary and Standby: Free within the same region.
Failover Traffic: No additional cost for the failover process.
Cross-Region Multi-AZ: Not supported; any cross-region replication would incur inter-region transfer costs.
Backup and Snapshot Traffic: No direct replication cost for backups, but copying snapshots across regions incurs inter-region data transfer costs.
Conclusion:
In a typical RDS Multi-AZ configuration, there are no additional network costs for replication traffic or failover when the primary and standby instances are within the same region. 
The only potential network-related cost would be for cross-region activities, but this does not apply to standard Multi-AZ setups.


------
Certainly! Here's the English translation of the explanation:

### What Are RDS Snapshots Used For?

Amazon RDS **Snapshots** capture a point-in-time snapshot of your database instance, allowing you to store and later restore this snapshot. RDS snapshots can be used for various purposes:

### 1. **Backup**
   - **Description**: RDS snapshots are used to take a **full backup** of your database. 
   This snapshot captures the state of the database at that particular point in time and can be used for restoration if needed.
   - **Example**: You can take regular snapshots (daily, weekly, monthly) to back up your database. 
   Once a snapshot is taken, any changes to the database after the snapshot are recorded separately.

### 2. **Database Restore**
   - **Description**: A snapshot can be used to restore a database to a previous state. 
   If a failure occurs or data is lost, the snapshot allows you to revert to that point in time.
   - **Example**: If incorrect data is inserted or deleted in the database, you can restore it from a snapshot to revert to a correct state.

### 3. **Database Migration**
   - **Description**: Snapshots can be used to **migrate** a database from one **AWS region** to another. This process allows you to replicate your database in another region and set up a new instance there.
   - **Example**: If you need to move your database to another region, you can take a snapshot and copy it to the new region to create a new database instance there.

### 4. **Testing and Development**
   - **Description**: Snapshots allow you to **clone** the database for use in **test and development** environments. 
   This is useful if you want to test new features or updates with real data without affecting the production system.
   - **Example**: You can take a snapshot of your production database and use it in a development environment to test new features or perform upgrades without any risk to the live system.

### 5. **Database Rebuild**
   - **Description**: If you need to **recreate** an RDS instance, you can take a snapshot of the current instance and later use it to create a new instance with the same data.
   - **Example**: If you want to delete and recreate your RDS instance, you can take a snapshot to ensure you can restore the database afterward.

### 6. **Create New Instances**
   - **Description**: You can use a snapshot to **create a new database instance** that is an exact copy of the original. This can be useful for scaling out your application or duplicating your database environment.
   - **Example**: If you want to create a new instance that mirrors your current database, you can use the snapshot to launch a new instance with the same data.

### 7. **Database Cloning**
   - **Description**: A snapshot allows you to **clone** a database instance, effectively creating an identical copy of the database that can be used elsewhere.
   - **Example**: If you need to clone a database to another user, environment, or application, you can use a snapshot to replicate the database on a new instance.

### 8. **Automated Snapshots (Automated Backups)**
   - **Description**: AWS RDS offers automated backups, which automatically create snapshots of your database at regular intervals. These snapshots are retained for a defined period and can be used for **point-in-time recovery (PITR)**.
   - **Example**: With automated snapshots, you can restore your database to a previous state if needed, without having to manually create snapshots.

### 9. **Game and Application State Backup**
   - **Description**: Especially for gaming or applications with frequently changing data, snapshots allow you to back up the state of the database at key points and restore it later if needed.
   - **Example**: For a game database storing player data, snapshots can be used to save the game state at important milestones and restore it when needed.

---

### Summary:
RDS snapshots are primarily used for **backups**, **restoration**, **database migration**, **testing/development**, **instance cloning**, and **recovery from system failures**. 
This tool provided by AWS helps minimize the risk of data loss, simplifies database migration, and allows you to use real data in testing environments.

*/

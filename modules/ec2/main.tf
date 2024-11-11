

resource "aws_instance" "instance" {
  ami                    = var.custom_ami_id != null ? var.custom_ami_id : lookup(var.ami_map, var.ami_name) #Find AMI with AMIs Name
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.use_security_groups
  iam_instance_profile   = var.instance_profile != null ? var.instance_profile : null
  user_data              = var.user_data_script != null ? var.user_data_script : null
  placement_group        = var.placementgroup_name != null ? var.placementgroup_name : null # Condition added
  availability_zone      = var.availability_zone != null ? var.availability_zone : null
  hibernation            = var.hibernation
  tags = {
    Name = var.instance_name
  }
}

/*

resource "aws_spot_instance_request" "spot_instance" {
  count                  = var.spot_price != "" ? 1 : 0
  ami                    = lookup(var.ami_map, var.ami_name) #Find AMI with AMIs Name
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.use_security_groups
  iam_instance_profile   = var.instance_profile != null ? var.instance_profile : null
  user_data              = var.user_data_script != null ? var.user_data_script : null
  spot_price             = var.spot_price
  placement_group        = var.placementgroup_name != null ? var.placementgroup_name : null # Condition added
  availability_zone      = var.availability_zone != null ? var.availability_zone : null
  tags = {
    Name = var.instance_name
  }
}
*/

/*
Amazon EC2 (Elastic Compute Cloud) is a cloud-based virtual server service provided by AWS. 
EC2 eliminates the need for purchasing and managing physical servers, allowing users to create and manage scalable virtual servers tailored to their needs.
With EC2, users can set up, run, and manage virtual servers (instances) in various configurations based on their requirements.

EC2 instance types are optimized for different workloads and performance needs. 
AWS offers numerous EC2 instance types customized for various usage scenarios:

1. General Purpose
These instances provide a balanced combination of CPU, memory, and network performance, ideal for general-purpose workloads.
T Series (T4g, T3, T3a): Cost-effective and burstable instances, suitable for low to moderate continuous workloads.
M Series (M6g, M5, M5a): General-purpose performance with a balance of memory and processing power, suitable for web servers, databases, application servers, and various workloads.

2. Compute Optimized
These instances are designed for applications that require high computing power.
C Series (C7g, C6g, C6i, C5): Optimized for CPU-intensive workloads. Ideal for high-performance computing, game servers, web servers, and scientific modeling that require extensive CPU usage.


3. Memory Optimized
Designed for applications that require high memory capacity.
R Series (R6g, R5, R5b): Suitable for workloads with high memory demands, such as databases, big data analytics, and data processing applications.
X Series (X2idn, X2iedn): Used in applications requiring high memory, such as data warehouses and large in-memory analytics.
z1d Series: Suitable for workloads requiring both high processing power and memory.

4. Storage Optimized
These instances are optimized for workloads that require high IOPS (Input/Output Operations Per Second).
I Series (I4i, I3): Ideal for low-latency, high-IOPS NoSQL databases and data processing applications.
D Series (D2, D3): Suitable for applications that need to store and process large amounts of data.
H Series (H1): Designed for storage-intensive workloads like big data analytics and data warehousing.

5. Accelerated Computing
Instances for specialized computing needs, such as graphics processing, AI, and deep learning
P Series (P4, P3): Provides GPU power for AI, deep learning, and machine learning applications.
G Series (G5, G4dn): Suitable for graphics processing applications, including 3D modeling, video processing, and gaming workloads.
Inf1: Specifically designed for machine learning inference workloads.

Use Cases for EC2 Instance Types


Each EC2 type is suited to different use cases. For example:
T Series offers a cost-effective solution for small and medium applications.
M Series supports a wide range of workloads, while C Series is ideal for CPU-intensive tasks.
R and X Series are suitable for memory-intensive workloads, I and D Series are designed for storage-heavy applications, and
P and G Series are tailored for high-performance tasks like graphics or AI processing.

Advantages of EC2
The advantages of EC2 include flexibility, scalability, cost savings, and diversity. 
Users can select different instance types based on their needs, launch new instances on-demand, and easily scale existing resources.

**EC2 Roles** are permission configurations defined by AWS Identity and Access Management (IAM) that can be assigned to EC2 instances, allowing them to securely access AWS resources. An EC2 role enables an instance to access AWS services (like S3, DynamoDB, etc.) without the need for manually configuring access credentials for a user or application.

EC2 roles simplify access management and enhance security. Here are some key features and common use cases for EC2 roles:

### Key Features of EC2 Roles

1. **Access to AWS Resources**: EC2 instances can have specific permissions based on the IAM role assigned to them, allowing them to interact with AWS services.
2. **Enhanced Security**: Roles eliminate the need for storing permanent access keys and secret keys within the instance, reducing security risks.
3. **Temporary Credentials**: When a role is assigned, the EC2 instance receives temporary security credentials that are automatically rotated by IAM, reducing the likelihood of security breaches.

### Use Cases for EC2 Roles

1. **S3 Access**: If an EC2 instance needs to access data in S3 (for example, for backups or data processing), an IAM role with S3 access permissions can be assigned to it.
   
2. **DynamoDB Access**: If an application on EC2 needs to read or write data to DynamoDB, you can assign a role that provides access to DynamoDB.

3. **CloudWatch Access**: If an EC2 instance needs to send metrics or logs to CloudWatch, a role with CloudWatch permissions can be added to enable data transmission.

4. **Systems Manager for Updates and Backups**: Systems Manager simplifies the management of EC2 instances. By assigning a role that grants Systems Manager permissions, you can use this service to automate system updates, backups, or command execution.

5. **Lambda Functions Integration**: An EC2 instance can have a role with permissions to trigger Lambda functions based on specific events or conditions.

### Steps to Define an EC2 Role

1. **Create a Role in IAM**: In the IAM console, create a role specific to EC2, and attach the necessary permission policies.
2. **Attach Role to EC2 Instance**: When launching a new instance or for an existing instance, assign the IAM role.
3. **Automatic Credential Provisioning**: Once the role is assigned, the instance automatically receives temporary credentials from AWS, enabling it to access the specified AWS resources.

EC2 roles allow applications to operate in the AWS environment securely, efficiently, and with easy-to-manage permissions. 
Using roles simplifies authentication management and enables controlled access to AWS resources for EC2 instances.

**Spot Instances** and **Spot Fleet Instances** are types of EC2 instances on AWS designed to reduce costs by utilizing unused AWS capacity. These instances are priced lower than other types due to their variable cost based on demand and carry the risk of being terminated by AWS when capacity is needed elsewhere.

### 1. Spot Instances
Spot Instances are low-cost instances offered by AWS from their unused EC2 capacity. Key features of Spot Instances include:

- **Low Cost**: Spot Instances significantly reduce costs depending on demand, often priced well below regular On-Demand prices.
- **Interruption Risk**: Spot Instances can be terminated by AWS at any time if capacity is needed for other customers. AWS provides a 2-minute warning before shutting down the instance.
- **Ideal for Short-Term or Fault-Tolerant Workloads**: Spot Instances are suitable for workloads that can tolerate interruptions or are short-term, such as big data analytics, batch processing, video processing, and rendering.

### 2. Spot Fleet Instances
A Spot Fleet is a collection of Spot and On-Demand instances managed together to achieve specific capacity and cost targets automatically. Key features of Spot Fleet include:

- **Automatic Capacity Management**: Spot Fleet launches and terminates instances as needed to meet the desired target capacity across different instance types and Availability Zones.
- **Backup and Flexibility**: Spot Fleet can use various instance types or Availability Zones to maintain target capacity. If capacity decreases or prices increase for one type, it switches to another instance type or region, ensuring stability.
- **Cost- and Capacity-Based Selection**: Spot Fleet uses strategies based on either cost or capacity. The “Lowest Price” strategy selects the most cost-effective instances, while the “Capacity Optimized” strategy selects instances based on available capacity.

### Use Cases for Spot Instances and Spot Fleet
- **Big Data Processing**: Spot Instances and Spot Fleet are commonly used in big data analysis due to their cost-effectiveness.
- **Batch and Rendering Processes**: Spot Instances are ideal for fault-tolerant tasks like video processing and 3D rendering.
- **Distributed Systems and Testing Environments**: Distributed architectures and testing environments, which are typically tolerant of interruptions, benefit from the cost savings of Spot Instances.

### Advantages of Spot Instances and Spot Fleet
- **Cost Savings**: Spot Instances can offer up to 90% savings compared to On-Demand instances.
- **Flexibility and Scalability**: Spot Fleet uses multiple instance types and Availability Zones to meet target capacity automatically.

AWS Spot Instances and Spot Fleet Instances are ideal for reducing costs in cloud workloads, providing significant cost advantages in fault-tolerant workloads.

**EC2 Placement Groups** are a feature in AWS that lets users influence the placement of their EC2 instances across AWS infrastructure to achieve specific network and performance requirements. Placement groups optimize the performance and connectivity of instances, making them ideal for applications that require high-speed, low-latency networking or specific redundancy levels.

There are three types of placement groups:

### 1. Cluster Placement Group
A **Cluster Placement Group** groups instances within a single Availability Zone in close proximity to each other. This type is designed to maximize network performance by minimizing latency and increasing bandwidth between instances.

- **Use Cases**: Suitable for applications that require very high network throughput and low latency, such as high-performance computing (HPC), large-scale data processing, and machine learning applications.
- **Considerations**: All instances in a Cluster Placement Group must be the same instance type, and there is a limit to the number of instances you can place in this group.

### 2. Spread Placement Group
A **Spread Placement Group** places each instance on distinct hardware, reducing the risk that a hardware failure will affect multiple instances in the group.

- **Use Cases**: Ideal for applications that require high availability and resilience, where each instance needs to be isolated from others to prevent single points of failure. Common in critical applications, databases, or workloads requiring strict fault tolerance.
- **Considerations**: Spread Placement Groups can span multiple Availability Zones within a Region, but there’s a limit on the number of instances that can be placed in a single Spread Placement Group (typically up to 7 instances per AZ).

### 3. Partition Placement Group
A **Partition Placement Group** divides instances into separate partitions, each on isolated sets of hardware within the same Availability Zone. Each partition is on separate racks, which provides hardware redundancy and minimizes impact if a single rack fails.

- **Use Cases**: Suitable for large distributed applications, like Hadoop, HDFS, or Cassandra, which benefit from being partitioned across multiple hardware failures.
- **Considerations**: Instances within a partition can communicate with each other through high-bandwidth, low-latency networking, while still being isolated from instances in other partitions.

### Choosing a Placement Group
- **Cluster**: For high network performance and low latency within a single AZ.
- **Spread**: For fault tolerance across multiple instances in different hardware racks.
- **Partition**: For large-scale distributed systems that need fault isolation while remaining on separate hardware.

Placement Groups provide flexibility in managing instance placement for performance optimization or fault tolerance, depending on the needs of the application.



**EC2 Hibernate** is a feature that allows you to save the state of an EC2 instance and, when restarted, resume from where it left off. This feature saves the instance's data to disk, and when the instance is restarted, the previous state is quickly restored, allowing applications and the system to continue from where they were without starting over.

When you enable hibernation, **EC2 instance** saves all the data in **RAM** to an **EBS (Elastic Block Store)** volume before shutting down. After the instance is stopped, the data is saved to EBS, and when the instance is restarted, the data is reloaded from EBS, and the system continues running from where it was before the shutdown.

### EC2 Hibernate Features:
1. **Quick Start**: Hibernate allows for a faster startup when the instance is restarted, as it restores the state from the saved data in EBS. This shortens the startup time, saving time.
2. **RAM Content Storage**: When an EC2 instance enters hibernation, the content of the RAM is saved to EBS. This allows the system to be restored without losing any data.
3. **EBS Requirement**: When using hibernation, the instance’s root EBS volume must have enough space to store the hibernation data.
4. **Restarting**: When the EC2 instance is restarted from hibernation, the previous state is restored, and the operating system and applications resume where they left off.

### Advantages of Using EC2 Hibernate:
- **Time Saving**: When the instance is restarted, the data in RAM is not lost. Applications continue from where they were, instead of restarting.
- **Application State Preservation**: Data like application states or user information is not lost, ensuring the application continues without interruption.
- **Cost Efficiency**: Hibernate saves on costs compared to fully stopping and starting the instance since the instance data is only written to disk and then restored.

### Limitations of EC2 Hibernate:
- **Supported Instance Types**: Not all EC2 instance types support hibernation. For example, some lower-powered instance types may not support hibernation. Instance types like `m5`, `m5a`, `r5`, `r5a`, `t3`, and `t3a` support hibernation.
- **Supported OS**: Hibernate is supported by certain operating systems, including Amazon Linux 2, Ubuntu, and Windows.
- **Root Volume Size**: The EC2 instance’s root EBS volume must be large enough (at least twice the size of the RAM).
- **Only EC2 Stop/Start**: Hibernate works only with the "Stop/Start" lifecycle actions. If you "Terminate" the instance, the hibernation data is lost.

### Terraform Usage for EC2 Hibernate

In this example, `hibernation = true` enables the hibernation feature for the EC2 instance. It is also important to ensure that the root block device has enough space to store the hibernation data.

### Conclusion

EC2 Hibernate is a useful feature that allows you to save the system state and quickly restart the instance from where it left off. This is particularly useful in scenarios where short-term shutdowns or application state preservation are required. However, not all EC2 instance types and operating systems support this feature, so selecting compatible types is crucial.
*/

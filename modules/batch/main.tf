resource "aws_batch_compute_environment" "this" {
  compute_environment_name = var.compute_environment_name
  type = "EC2"
  compute_resources {
    type              = "EC2"
    min_vcpus         = var.min_vcpus
    max_vcpus         = var.max_vcpus
    subnets           = var.subnets
    security_group_ids = var.security_group_ids
    instance_role     = var.instance_role
  }
  service_role = var.service_role
  state        = "ENABLED"
}

resource "aws_batch_job_queue" "this" {
  name                = var.job_queue_name
  priority            = var.job_queue_priority
  state               = "ENABLED"

    compute_environment_order {
    order               = 1
    compute_environment = aws_batch_compute_environment.test_environment_1.arn
  }
}

resource "aws_batch_job_definition" "this" {
  name = var.job_definition_name
  type = "container"

  container_properties = jsonencode({
    image   = var.container_image
    vcpus   = var.vcpus
    memory  = var.memory
    command = var.command
  })
}



/*
**What is AWS Batch?**

**AWS Batch** is a service provided by Amazon Web Services that enables users to efficiently run container-based workloads. It is designed for managing and executing high-volume batch jobs. AWS Batch automates job scheduling and resource management, allowing for large-scale parallel processing.

### **Key Features of AWS Batch**
1. **Job Management:**
   - AWS Batch organizes jobs using job queues.
   - Jobs are executed based on their priority.

2. **Resource Provisioning:**
   - Automatically provisions the type and amount of resources needed, running on EC2 or AWS Fargate.
   - Supports both Spot Instances and On-Demand Instances.

3. **Container Support:**
   - Integrated with Amazon ECS (Elastic Container Service) to support container-based jobs.
   - Enables running Docker containers.

4. **Flexibility and Scalability:**
   - AWS Batch scales workloads automatically based on demand.
   - Offers cost-effective solutions for small-scale jobs.

5. **Integration:**
   - Easily integrates with other AWS services like AWS Lambda, Amazon S3, Amazon RDS, and DynamoDB.
   - For instance, an S3 file upload can trigger a job in AWS Batch.

6. **Compute Environment:**
   - Allows defining various compute environments for running jobs.
   - Environments can be managed or unmanaged.

### **How Does AWS Batch Work?**
1. **Creating Job Queues:** Jobs are collected in a prioritized queue.
2. **Defining Compute Environments:** AWS Batch automatically provisions the infrastructure to run jobs.
3. **Defining Jobs:** Each job specifies container images, commands, and required resources.
4. **Executing Jobs:** AWS Batch runs jobs in order and performs automatic scaling.
5. **Managing Results:** Job outputs can be stored in a storage service like Amazon S3.

### **Use Cases of AWS Batch**
- **Scientific Computing:** DNA analysis, astronomy calculations.
- **Media Processing:** Video transcoding and processing.
- **Data Analytics:** Processing and analyzing large datasets.
- **Machine Learning:** Running training processes in parallel.

AWS Batch is particularly advantageous for big data processing and analysis projects as it automates resource management and ensures users only pay for what they use.

*/



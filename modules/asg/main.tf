resource "aws_launch_template" "launch_template" {
  name_prefix   = "${var.template_name}-"
  image_id      = var.ami_id
  instance_type = var.instance_type

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = var.security_groups
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              # Use this for your user data (script from top to bottom)
              # install httpd (Linux 2 version)
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Hello World from $(hostname -f)</h1>" > /var/www/html/index.html
              EOF
  )
}

resource "aws_autoscaling_group" "asg" {
  desired_capacity    = var.desired_capacity
  max_size            = var.max_size
  min_size            = var.min_size
  vpc_zone_identifier = var.subnet_ids
  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
  }

  health_check_type         = var.health_check_type
  health_check_grace_period = 300

  target_group_arns = var.target_group_arn # ALB Target Group ile bağlanma


  tag {
    key                 = "Name"
    value               = var.asg_name
    propagate_at_launch = true
  }
}






/*
Sure! Here's the translation:

**Auto Scaling Group (ASG)** is a service used in AWS (Amazon Web Services) that enables automatic scaling. 
This group allows the number of **EC2 instances** to dynamically increase or decrease based on workload requirements.

### Key Features of ASG:
1. **Automatic Scaling:** Based on high traffic or workload requirements, ASG automatically starts or stops EC2 instances. 
This ensures more efficient resource usage and cost savings.
   
2. **Health Checks:** ASG monitors the health status of EC2 instances. 
If an instance is unresponsive or fails, a new one is automatically launched.

3. **Cross-Zone Distribution:** ASG distributes instances across multiple **Availability Zones (AZs)**, ensuring high availability and fault tolerance. 
This allows instances to run in different regions, making them resilient to failures in any one zone.

4. **Minimum and Maximum Instance Count Settings:** ASG allows you to define minimum and maximum EC2 instance counts, scaling automatically within these limits. 
Additionally, the **Desired Capacity** can be set to maintain a specific number of active instances.

5. **Time-Based Scaling:** If the load varies at different times, ASG can apply time-based rules to adjust the number of instances according to specific hours.

### Benefits of ASG:
- **Cost Efficiency:** It optimizes resource usage by running more instances when traffic increases and reducing resources when traffic decreases, saving costs.
- **High Availability:** Since instances run across multiple AZs, the application continues to function even if one AZ fails.
- **Flexibility:** ASG offers flexibility by automatically scaling resources based on the load, allowing more resources when needed and reducing them during low demand.

ASGs are typically used for web applications, microservices, data processing, and similar use cases.



Sure! Here's the translation:

**Auto Scaling** with **CloudWatch** for scaling automatically adjusts the number of EC2 instances based on workload, 
using CloudWatch metrics to trigger scaling actions when specific conditions are met. AWS Auto Scaling works by monitoring CloudWatch metrics and using them to scale resources dynamically according to predefined scaling policies.

### Steps for Scaling with Auto Scaling and CloudWatch:

1. **CloudWatch Alarms**:
   - AWS CloudWatch collects and monitors various metrics (CPU usage, memory, disk I/O, network traffic, etc.) for your system.
   - These metrics are used as triggers for Auto Scaling to take action when specific conditions are met. 
   CloudWatch alarms are triggered when a metric value (e.g., CPU usage exceeding 80%) is breached.
   
2. **Scaling Policy Creation**:
   - CloudWatch alarms trigger a scaling policy when a certain threshold is reached (e.g., CPU usage exceeds 80%).
   - Scaling policies define the action to take in response to the alarm, such as:
     - **Scale-out:** Launch more instances when the load increases.
     - **Scale-in:** Reduce the number of instances when the load decreases.
   
3. **CloudWatch Alarm Triggers**:
   - CloudWatch alarms trigger Auto Scaling actions. For example, if an alarm is triggered due to CPU usage exceeding 75%, Auto Scaling will start additional EC2 instances. 
   Conversely, if CPU usage falls below 40%, the alarm will trigger a scale-in action to reduce the instances.

4. **Types of Scaling Policies**:
   - **Simple Scaling:** In this type, when an alarm is triggered, Auto Scaling performs a single action (e.g., starting or stopping one instance).
   - **Step Scaling:** This allows more complex rules. For example, if CPU usage exceeds 75%, launch 2 instances; if it exceeds 90%, launch 3 instances.
   - **Target Tracking Scaling:** In this type, Auto Scaling maintains the system around a target value (e.g., keeping CPU usage at 50%) by adjusting the number of instances accordingly.

5. **Monitoring Scaling Events**:
   - CloudWatch logs every scaling event, such as which alarms were triggered, what scaling policies were applied, and how many instances were launched or terminated.

### Example Scenario:
Let's say you have a web application and you want to launch more EC2 instances when CPU usage exceeds 80%. In this case:
- **CloudWatch Alarm:** A CloudWatch alarm is triggered when CPU usage exceeds 80%.
- **Auto Scaling Scaling Policy:** The scaling policy for Auto Scaling is to launch a new EC2 instance when the alarm is triggered.
- **CloudWatch Metrics & Monitoring:** Auto Scaling continues to monitor and, if necessary, scales in or out depending on the load, using other alarms.

### Benefits of Auto Scaling with CloudWatch:
- **Dynamic Resource Management:** Scale resources up or down automatically based on system demand in real-time.
- **Comprehensive Monitoring:** CloudWatch allows you to monitor all metrics, helping you optimize resource usage.
- **Automation:** Scaling actions are performed automatically without the need for manual intervention, ensuring optimal performance.

In this way, Auto Scaling and CloudWatch work together to efficiently manage your AWS infrastructure and ensure high availability.


Sure! Here's the translation:

**Auto Scaling Group (ASG)** provides various **metrics** that AWS uses to monitor application performance and resource utilization. These metrics help Auto Scaling make the right scaling decisions and enable monitoring the health of the system.

### Key ASG Metrics:

1. **Group Desired Capacity**:
   - This metric indicates the number of active EC2 instances that the Auto Scaling group wants to maintain. It represents the desired number of instances, which may not always match the actual state.

2. **Group InService Instances**:
   - This metric shows the number of EC2 instances currently running and considered healthy within the Auto Scaling group.

3. **Group Pending Instances**:
   - This metric shows the number of EC2 instances that Auto Scaling is trying to launch but are not yet active.

4. **Group Standby Instances**:
   - This metric indicates the number of instances that are in standby mode within the Auto Scaling group. These instances are ready to be activated when additional scaling is needed.

5. **Group Terminating Instances**:
   - This metric shows the number of EC2 instances that are being terminated by Auto Scaling. Instances are terminated when there is low demand to free up resources.

6. **Group Max Size**:
   - This metric specifies the maximum number of EC2 instances the Auto Scaling group can scale up to. It represents the upper limit of scaling defined by Auto Scaling.

7. **Group Min Size**:
   - This metric defines the minimum number of EC2 instances that Auto Scaling will maintain in the group. The Auto Scaling group will ensure that at least this many instances are running based on the scaling policy.

8. **CPU Utilization**:
   - This metric monitors the CPU usage of EC2 instances. High CPU utilization may indicate the need for additional instances.

9. **Network In/Out**:
   - This metric tracks the incoming and outgoing network traffic of EC2 instances. High network traffic may indicate that additional instances are required to handle the load.

10. **Disk Read/Write**:
    - This metric monitors disk read and write operations on EC2 instances. High disk usage may suggest that more instances are needed to handle the workload.

11. **Healthy Host Count**:
    - This metric tracks the health status of EC2 instances. Instances that are unhealthy are automatically terminated, and new instances are launched to replace them.

12. **ASG Scaling Activity**:
    - This metric tracks past activities related to scaling in the Auto Scaling group, such as when instances were added or removed.

13. **Instance Health**:
    - This metric monitors the health of individual instances. If an instance encounters health issues, Auto Scaling will detect it and automatically launch a replacement instance.

### Usage of ASG Metrics:
- **Scaling Decision:** These metrics help Auto Scaling decide when to launch new instances or terminate existing ones.
- **Performance Monitoring:** Metrics like high CPU usage, high network traffic, or disk read/write operations can be used to monitor and manage the performance of the application.
- **Capacity Management:** Auto Scaling uses these metrics to adjust minimum and maximum capacity, dynamically managing resources based on the current demand.

These metrics enable Auto Scaling to efficiently and automatically manage resources, quickly adapting to the needs of your application.

Certainly! Here's the translation:

**Auto Scaling Groups (ASG)** work with **Availability Zones (AZs)** and **subnets** to dynamically manage application capacity, ensuring high availability and resilience. ASG uses load balancing and auto-scaling to scale resources up or down based on demand. Here’s how ASG works with **AZs** and **subnets**:

### 1. **ASG and Availability Zones (AZ) Interaction**

- **AZ Distribution:**
  - ASG can be distributed across **multiple Availability Zones**. This is critical for **high availability**. By spreading EC2 instances across multiple AZs, ASG ensures that if one AZ fails, the application can continue running.
  - For example, an ASG might run **2 AZs** and distribute EC2 instances between them, balancing the load, and ensuring that if one AZ fails, the other AZs will still handle traffic.

- **Instance Distribution Across AZs:**
  - When creating an ASG, you can define the **minimum and maximum instance count** for each AZ. This helps distribute instances effectively. For example, if the total number of instances is 6, ASG can distribute 3 instances to each AZ.

- **Health Checks:**
  - ASG monitors the health of EC2 instances in each AZ. If an instance fails, ASG will launch a new instance and place it in the appropriate AZ. Health checks are critical for ensuring high availability, as failed instances are automatically replaced.

### 2. **ASG and Subnet Interaction**

- **Subnets and AZ Relationship:**
  - Each **subnet** belongs to a specific **Availability Zone**. An ASG’s EC2 instances are placed in subnets within the AZs.
  - If an ASG supports **multiple AZs**, different subnets can be created in each AZ, and instances will be distributed across these subnets. Each subnet will have its own IP address range defined within the respective AZ.

- **Public and Private Subnets:**
  - **Public Subnets:** Typically host resources that need internet access (e.g., web servers or load balancers). ASG can place instances in **public subnets** to provide internet access to the EC2 instances.
  - **Private Subnets:** These typically house resources that do not require internet access (e.g., databases or application servers). ASG places instances in **private subnets** and can use **NAT Gateway** or **VPC Peering** to allow internet access for instances within private subnets.

- **Subnet Distribution:**
  - ASG can distribute instances across **multiple subnets**, which can be located in different AZs. This allows you to set up **high availability** and distribute load across subnets, ensuring that there are always instances running in at least a few subnets.
  
### 3. **ASG and Load Balancing with AZs and Subnets**

- **Load Balancer and AZs:**
  - ASG integrates with **Application Load Balancer (ALB)** or **Network Load Balancer (NLB)** to distribute traffic across EC2 instances in different **Availability Zones**. The load balancer helps balance the load between instances in different AZs, ensuring that traffic is routed to healthy instances, improving fault tolerance.
  - The load balancer distributes traffic across EC2 instances in **different AZs** and **subnets**, ensuring high availability even if an AZ fails.

- **ASG Scale-in/Scale-out:**
  - **Scale-out (Scaling Up):** When demand increases, ASG will launch new instances and place them across different **subnets and AZs**.
  - **Scale-in (Scaling Down):** When demand decreases, ASG will terminate instances and redistribute them across fewer subnets and AZs.

### 4. **Configuring ASG with AZs and Subnets**

- **Scaling Strategy:**
  - By using multiple AZs, you can achieve **load balancing** and **high availability**. Distributing subnets across each AZ helps ensure that if one AZ fails, your application can continue to operate.

- **ASG Configuration:**
  - When configuring an ASG, you define the minimum and maximum capacity, as well as the number of instances to place in each AZ and subnet. ASG can scale the application effectively based on demand and distribute instances across the AZs and subnets.

### In Summary:
- **ASG works with AZs and subnets** to provide high availability and resilience. 
- **Availability Zones** distribute EC2 instances across multiple locations to ensure your application continues to run if one AZ fails.
- **Subnets** place each instance in specific AZs, and by configuring them across multiple AZs and subnets, you ensure proper scaling and high availability for your application.
*/

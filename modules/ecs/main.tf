resource "aws_kms_key" "example" {
  description             = "example"
  deletion_window_in_days = 7
}

resource "aws_cloudwatch_log_group" "example" {
  name = "example"
}

resource "aws_ecs_cluster" "test" {
  name = "example"

  configuration {
    execute_command_configuration {
      kms_key_id = aws_kms_key.example.arn
      logging    = "OVERRIDE"

      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.example.name
      }
    }
  }
}

resource "aws_ecs_task_definition" "my_task_definition" {
  family                   = "my-task-definition"
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([{
    name      = "nginx-container"
    image     = "nginx:latest"
    essential = true
    portMappings = [{
      containerPort = 80
      hostPort      = 80
    }]
  }])
}

resource "aws_ecs_service" "my_ecs_service" {
  name            = "my-ecs-service"
  cluster         = aws_ecs_cluster.example.id
  task_definition = aws_ecs_task_definition.my_task_definition.arn
  desired_count   = 2
  launch_type     = "EC2"

  network_configuration {
    subnets          = []
    security_groups  = []
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.my_target_group.arn
    container_name   = "nginx-container"
    container_port   = 80
  }

  depends_on = [aws_lb_listener.my_lb_listener]
}

resource "aws_launch_configuration" "my_launch_config" {
  name            = "my-launch-config"
  image_id        = "ami-xxxxxxxx" # EC2 AMI ID
  instance_type   = "t2.micro"
  security_groups = []
}

resource "aws_autoscaling_group" "my_asg" {
  desired_capacity    = 2
  max_size            = 10
  min_size            = 1
  vpc_zone_identifier = []

  launch_configuration = aws_launch_configuration.my_launch_config.id

  health_check_type         = "EC2"
  health_check_grace_period = 300
  force_delete              = true
}


resource "aws_lb" "my_lb" {
  name               = "my-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = []
  subnets            = []

  enable_deletion_protection = false
}

resource "aws_lb_target_group" "my_target_group" {
  name     = "my-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "vpc-xxxxxxxx"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

resource "aws_lb_listener" "my_lb_listener" {
  load_balancer_arn = aws_lb.my_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_target_group.arn
  }
}


resource "aws_appautoscaling_target" "my_service_scaling_target" {
  max_capacity       = 10
  min_capacity       = 2
  resource_id        = "service/${aws_ecs_cluster.my_ecs_cluster.name}/${aws_ecs_service.my_ecs_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "my_service_scaling_policy" {
  name               = "my-service-scaling-policy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.my_service_scaling_target.resource_id
  scalable_dimension = aws_appautoscaling_target.my_service_scaling_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.my_service_scaling_target.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = 50.0 # CPU kullanımının hedef değeri
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    scale_in_cooldown  = 300
    scale_out_cooldown = 300
  }
}






/*
AWS ECS (Elastic Container Service) is a fully managed container orchestration service offered by Amazon Web Services. ECS is used to deploy, manage, and scale Docker containers, enabling users to run container-based applications securely and efficiently, such as microservices or other application components.  

### Key Features of ECS:  

1. **Container Orchestration:**  
   ECS automates tasks like starting, stopping, monitoring, and managing containers. This is especially important for large and complex applications.  

2. **Integrated Deployment:**  
   ECS works with Amazon EC2 instances or AWS Fargate. EC2 provides infrastructure for running containers on physical servers, while Fargate lets you run containers without managing the underlying infrastructure.  

3. **Scalability:**  
   You can automatically scale the number of containers based on your application’s needs. This allows for quick adaptation to traffic spikes or load changes.  

4. **Built-in Security:**  
   ECS integrates with IAM (Identity and Access Management) for identity and access management. Network security and data encryption features can also be added to containers.  

5. **Efficient Management:**  
   ECS monitors your application's health and can restart containers using automated strategies to ensure high availability.  


**Amazon ECS EC2 Launch Type** is a method of running containers on Amazon EC2 instances using AWS ECS. In this model, users create, manage, and run containers on their own EC2 instances. It is ideal for applications requiring full control and customization.  

### **Features of Amazon ECS EC2 Launch Type:**  

1. **Full Control:**  
   Users can choose and manage EC2 instance types, operating systems, network configurations, and storage options.  

2. **Customized Configuration:**  
   You can configure EC2 instances to meet your application’s specific requirements, such as adjusting CPU, memory, and disk capacity as needed.  

3. **Deep AWS Integration:**  
   EC2 Launch Type integrates deeply with AWS services, such as:  
   - **Auto Scaling:** Automatically scale EC2 instances based on traffic load.  
   - **Elastic Load Balancing (ELB):** Distribute traffic to containers.  
   - **IAM Roles:** Ensure access control for applications and ECS services.  

4. **Container Density:**  
   You can run multiple containers on a single EC2 instance, reducing costs and optimizing resource usage.  

5. **Application Resilience:**  
   ECS monitors the state of EC2 instances and containers to keep applications running reliably.  

### **When to Use Amazon ECS EC2 Launch Type:**  
- When full control over resources is required  
- If your workload has variable resource demands  
- When customized network and security configurations are needed  
- If you plan to optimize costs by using different EC2 instance types  

**Alternative:**  
If you want to minimize infrastructure management, you can use **AWS Fargate Launch Type**, where containers run without the need to manage EC2 instances.



**AWS Fargate Launch Type** is a mode in Amazon ECS that allows you to run containers without managing EC2 instances. Fargate automatically provisions and manages the underlying compute resources, enabling a serverless container experience. This makes it ideal for deploying containerized applications with minimal infrastructure management.  

---

### **Key Features of AWS Fargate Launch Type:**  

1. **Serverless Infrastructure:**  
   - No need to provision, scale, or manage EC2 instances.  
   - AWS automatically handles compute capacity based on the specified CPU and memory for containers.  

2. **Simplified Scaling:**  
   - Applications automatically scale up or down based on demand.  
   - Pay only for the resources consumed by your running containers.  

3. **Enhanced Security:**  
   - Each container runs in its own isolated environment.  
   - Integrated with IAM roles, VPC, security groups, and data encryption services.  

4. **Seamless Integration:**  
   - Works with Amazon ECS and EKS.  
   - Supports AWS services like CloudWatch, ELB, Secrets Manager, and IAM.  

5. **No Cluster Management:**  
   - Eliminates the need to manage clusters or EC2 Auto Scaling Groups.  
   - Focus on container deployment, task definition, and scaling policies.  

---

### **When to Use AWS Fargate Launch Type:**  

- **Microservices and APIs:** Run individual services without managing servers.  
- **Event-Driven Applications:** Process data streams or events automatically.  
- **CI/CD Pipelines:** Deploy new containerized code quickly.  
- **Batch Jobs and Data Processing:** Handle large-scale tasks efficiently.  

---

**Comparison with EC2 Launch Type:**  
| **Feature**               | **Fargate Launch Type**   | **EC2 Launch Type**      |
|--------------------------|----------------------------|--------------------------|
| Infrastructure Management | Fully managed (serverless) | User-managed EC2 instances |
| Scaling                  | Automatic, resource-based | Manual or Auto Scaling   |
| Cost Model               | Pay per container usage   | Pay for EC2 instances    |
| Customization            | Limited instance control  | Full instance customization |
| Use Case                 | Simple, fast deployments  | Complex, custom setups   |

Fargate Launch Type is perfect for developers seeking a fully managed container platform while focusing solely on application development and deployment.




### **What is an ECS Cluster?**  

An **ECS Cluster** is a logical grouping of resources where your containers run in Amazon ECS. It manages infrastructure resources such as EC2 instances or Fargate tasks. ECS clusters serve as the core building block for deploying, scaling, and managing containerized applications.  

#### **Types of ECS Clusters:**  
1. **EC2 Launch Type Cluster:**  
   - Runs containers using EC2 instances.  
   - Requires manual infrastructure management.  

2. **Fargate Launch Type Cluster:**  
   - AWS manages the infrastructure for you (serverless).  
   - You only define and run your applications.  

#### **Key Features:**  
- **Resource Management:** You can run multiple services and tasks within the same cluster.  
- **Auto Scaling:** Add more EC2 instances or start new Fargate tasks when load increases.  
- **Networking and Security:** Configure security using VPCs, security groups, and IAM roles.  

---

### **What is an ECS Task?**  

An **ECS Task** is the unit of work in Amazon ECS. It represents a running instance of your application. Each task contains one or more containers and is launched based on a **Task Definition**, which specifies how the task should run.  

#### **ECS Task Components:**  

1. **Task Definition:**  
   - Defines how tasks should run.  
   - Includes container image, CPU and memory settings, environment variables, port configurations, and IAM roles.  

2. **Container Definition:**  
   - Specifies detailed container settings.  
   - Includes Docker image, port mappings, and command-line parameters.  

3. **Networking:**  
   - Tasks running on Fargate have their own ENI (Elastic Network Interface).  
   - Tasks running on EC2 instances share the network resources of the host instance.  

#### **Task Execution Modes:**  

- **Manual Tasks:** Suitable for one-time tasks (e.g., database updates).  
- **Service Tasks:** Ideal for continuously running tasks (e.g., API servers).  

---

### **Relationship Between ECS Cluster and ECS Task:**  

- An **ECS Cluster** can contain multiple **ECS Tasks**.  
- Tasks are distributed and run within the cluster based on task definitions.  
- ECS monitors tasks and restarts them if necessary.  

This architecture enables Amazon ECS to create scalable, highly available, and flexible containerized applications.


**ECS Service** in Amazon ECS is a managed group of tasks that continuously runs and maintains a specific number of tasks within the cluster. An ECS service is used to manage and ensure that your application runs reliably and can scale as needed.

### **Key Features of ECS Service:**

1. **Continuous Running Tasks:**
   - The ECS service ensures that a specific number of tasks are always running.
   - If a task fails, the ECS service automatically restarts a new task.

2. **Load Balancing:**
   - ECS services can be integrated with an **Elastic Load Balancer** (ALB or NLB), which directs incoming traffic to the tasks and helps your application run more efficiently.

3. **Auto Scaling:**
   - ECS services can automatically adjust the number of tasks based on certain conditions, allowing your application to scale in response to traffic.

4. **Version Control:**
   - ECS services can run specific task versions, and smooth updates can be made when transitioning to a new task definition version.

5. **Deployment Modes:**
   - **Rolling Update:** Updates are performed by starting new tasks before terminating old ones.
   - **Blue/Green Deployment:** Both old and new versions can run simultaneously, and traffic is shifted to the new version once it’s ready.

### **Use Cases for ECS Service:**
- **Web Applications and APIs:** Ideal for web servers or API services that need to run continuously.
- **Microservices:** You can create an ECS service for each microservice in a microservices architecture.
- **Automatic Load Balancing:** Distributes traffic evenly across tasks to ensure high availability for web applications.

An ECS Service is a powerful tool to ensure that your applications are highly available and scalable.


Here’s a comparison between **ECS Cluster**, **ECS Service**, and **ECS Task** to clarify their roles in Amazon ECS:

### **1. ECS Cluster**
- **Definition:** An ECS Cluster is a logical grouping of resources where your tasks (and services) run. It can contain EC2 instances (for EC2 launch type) or Fargate tasks (for Fargate launch type).
- **Purpose:** It provides a place for your ECS services and tasks to run. A cluster allows you to organize and manage your resources efficiently.
- **Components:**
  - EC2 instances or Fargate tasks (depending on the launch type).
  - Tasks are scheduled to run on the cluster.
  - It’s the foundation of ECS that enables resource management.

---

### **2. ECS Service**
- **Definition:** An ECS Service is a long-running task or a group of tasks that ensure a specific number of tasks are always running. It is associated with an ECS Cluster and provides the ability to run and maintain application containers.
- **Purpose:** It helps you manage tasks by ensuring that a desired number of tasks are running at all times. ECS services are used for highly available applications that need continuous execution.
- **Key Features:**
  - Automatic task replacement if a task fails.
  - Load balancing and integration with an Elastic Load Balancer (ALB or NLB).
  - Supports auto-scaling to meet demand.
  - Supports version control and smooth updates via rolling or blue/green deployment.
  
---

### **3. ECS Task**
- **Definition:** An ECS Task is the basic unit of work in ECS. It represents a running instance of your application defined in a Task Definition.
- **Purpose:** ECS tasks are the actual workloads that execute within ECS. Each task runs a set of containers that are defined in a Task Definition.
- **Components:**
  - One or more containers (Docker containers) defined by a Task Definition.
  - Task Definitions contain container configuration, CPU, memory, environment variables, and IAM roles.
- **Execution Types:**
  - **EC2 Launch Type:** The task runs on EC2 instances within the ECS cluster.
  - **Fargate Launch Type:** The task runs serverless, and AWS manages the infrastructure.

---

### **Key Differences:**

| **Feature**         | **ECS Cluster**                                    | **ECS Service**                                     | **ECS Task**                                  |
|---------------------|----------------------------------------------------|-----------------------------------------------------|-----------------------------------------------|
| **Definition**       | Logical group of resources (EC2 instances or Fargate tasks). | Long-running tasks that ensure a specified number of tasks are running. | A single running task (container group) based on Task Definition. |
| **Purpose**          | Groups resources and organizes tasks and services. | Manages long-running, scalable applications. | Executes a containerized application or job. |
| **Components**       | EC2 instances or Fargate tasks.                   | Tasks managed by the service, optionally linked to load balancers. | Containers defined in a Task Definition.     |
| **Management**       | Provides resource management and scheduling.       | Ensures desired number of tasks are running, handles scaling. | Represents a running application, defined by a task definition. |
| **Scaling**          | ECS manages the distribution of tasks within the cluster. | Auto-scaling tasks based on demand.                  | Task execution is independent but can be scaled via services. |
| **Failure Handling** | ECS clusters do not handle failure directly.       | Automatically replaces failed tasks.                 | No auto-replacement; it’s part of the service or manually restarted. |

### **Summary:**
- **ECS Cluster** is the environment where resources are grouped and managed.
- **ECS Service** ensures that a certain number of tasks are always running, maintaining the availability of your application.
- **ECS Task** is the individual unit of execution, where containers run based on a task definition. 

Each of these components plays a different role, but together they form the foundation of containerized application management in ECS.


In Amazon ECS, **IAM roles** are essential for controlling permissions and access to AWS services and resources. Different roles are associated with **ECS Clusters**, **ECS Services**, and **ECS Tasks** to manage security and resource access. Here’s a breakdown of the different IAM roles required for each component:

### **1. ECS Cluster Role**
The **ECS Cluster Role** is associated with the underlying infrastructure that ECS uses to manage the tasks and services within the cluster. This role typically grants permissions for ECS to manage and interact with other AWS services needed by the cluster.

#### **ECS Cluster Role Permissions:**
- **EC2 Instances:** If you are using EC2 instances to run your tasks, the ECS Cluster Role is required for the EC2 instances to interact with ECS. This role allows EC2 instances to register themselves with the ECS cluster.
  - **AmazonEC2ContainerServiceforEC2Role** policy is often attached to the role.
  - The EC2 instance role should also allow interaction with other services like CloudWatch (for logs), ELB (for load balancing), and ECR (for Docker images).

#### **Role Purpose:**
- Allows EC2 instances to register and join the ECS Cluster.
- Grants the ECS service permission to manage container instances (EC2 or Fargate) within the cluster.
- Enables logging and monitoring of tasks in Amazon CloudWatch.

### **2. ECS Service Role**
An **ECS Service Role** is used to manage the ECS Service itself. This role typically provides permissions to ECS to manage tasks, perform scaling actions, and integrate with other services like load balancers.

#### **ECS Service Role Permissions:**
- **Service Discovery:** Allows ECS to register and manage service instances with **AWS Cloud Map** for service discovery.
- **Elastic Load Balancer (ELB):** ECS services often use load balancers (ALB/NLB). The ECS service role grants ECS permission to register and deregister tasks with the load balancer.
- **Auto Scaling:** Grants ECS the permission to scale the service up or down based on demand.
- The **AmazonEC2ContainerServiceRole** policy is usually attached to the role.

#### **Role Purpose:**
- Allows ECS to register tasks with the load balancer.
- Provides the ability to scale the ECS service (if auto-scaling is enabled).
- Ensures service discovery functionality if used with AWS Cloud Map.

### **3. ECS Task Role**
An **ECS Task Role** is a role associated with an individual ECS Task. This role is used to grant the tasks (containers) running in ECS permissions to access AWS services and resources.

#### **ECS Task Role Permissions:**
- **Access to AWS Services:** You can define specific permissions for your containers to interact with other AWS services, such as S3, DynamoDB, Secrets Manager, etc.
  - For example, if your container needs to read data from an S3 bucket or interact with an RDS database, the ECS Task Role will have the appropriate permissions attached.
- **AWS SDK:** The ECS Task Role grants permissions that can be accessed by the application within the container (via SDKs).
  
#### **Role Purpose:**
- Grants the containerized application permissions to access AWS services (S3, DynamoDB, Secrets Manager, etc.).
- Can be specific to the task, providing the principle of least privilege.

### **Summary of IAM Roles:**

| **Component**            | **Role Name**                    | **Purpose**                                                      | **Permissions**                                                    |
|--------------------------|----------------------------------|------------------------------------------------------------------|--------------------------------------------------------------------|
| **ECS Cluster**           | `ecsInstanceRole`                | Allows EC2 instances to interact with ECS cluster.               | EC2 permissions to join ECS cluster, access CloudWatch, ELB, ECR. |
| **ECS Service**           | `ecsServiceRole`                 | Manages service-specific tasks and integrates with other AWS services like load balancers. | Permissions to register tasks with ELB, perform auto-scaling, and service discovery. |
| **ECS Task**              | `ecsTaskRole`                    | Allows ECS tasks to interact with other AWS services.            | Permissions to access S3, DynamoDB, or other AWS services from within the container. |

### **Additional Notes:**
- **Task Role** is always defined in the ECS **Task Definition** and is specific to the task.
- **Service Role** is defined at the ECS Service level and allows the ECS service to interact with other AWS resources.
- The **Cluster Role** is mainly related to EC2 instances (in EC2 launch type) and allows them to interact with ECS, but it can also apply to Fargate if needed.

Each of these roles helps provide secure, fine-grained access to resources in AWS, ensuring that ECS tasks, services, and clusters can function correctly with the necessary permissions.

In Amazon ECS, the **Load Balancer** is directly connected to the **ECS Service**, not the **ECS Cluster**.

### **Load Balancer and ECS Integration:**

1. **Load Balancer and ECS Service Connection:**
   - The **ECS Service** manages one or more ECS Tasks, so the **Load Balancer** is connected directly to the **ECS Service**.
   - The Load Balancer targets the tasks managed by the **ECS Service**. The **Target Groups** associated with the ECS Service point to the IP addresses or EC2 instances running the ECS tasks (containers).
   - The **ECS Service** is the entity that directs traffic to **ECS Tasks** or **EC2 Instances**, not the **ECS Cluster**.

2. **ECS Cluster Connection:**
   - The **ECS Cluster** is a grouping of resources that run **ECS Tasks** or **ECS Services**, but the **Load Balancer** is connected to the **ECS Service**, not directly to the **Cluster**.
   - The **ECS Cluster** merely provides the resources where tasks and services run, but the load balancing and traffic routing are done at the **ECS Service** level.

### **How ECS Service and Load Balancer Integration Works:**
- The **ECS Service** runs a specific number of **ECS Tasks**. Each ECS Task is registered in the **Target Group** associated with the Load Balancer.
- **Health Checks** and **Load Balancer** rules ensure traffic is routed only to healthy ECS tasks.
- If the ECS service adds or removes tasks from its target group, the **Load Balancer** listens to these changes and routes traffic to the new tasks in the target group.

### **Summary:**
- The **Load Balancer** is directly connected to the **ECS Service**, not the **ECS Cluster**.
- The **ECS Service** exposes tasks to the Load Balancer, manages traffic routing, and load balancing.



In Amazon ECS, **Data Volumes** are used to store persistent data for tasks and containers. By default, containers in ECS are stateless, meaning they do not retain data once a task stops or is terminated. To overcome this limitation and ensure data persistence across task restarts, ECS allows you to use data volumes.

There are two main types of data volumes in ECS:

### 1. **EBS (Elastic Block Store) Volumes**
EBS volumes are block-level storage devices that can be attached to ECS instances (for EC2 launch type) or tasks (for Fargate launch type). EBS provides persistent storage that persists beyond the lifecycle of a container.

#### **How EBS Volumes Work with ECS:**
- EBS volumes can be attached to EC2 instances running ECS tasks.
- When using ECS with the **EC2 Launch Type**, EBS volumes can be mounted to containers in the tasks running on EC2 instances.
- For **Fargate Launch Type**, you can use EFS (Elastic File System) for shared persistent storage, but you cannot directly attach EBS volumes to Fargate tasks.

#### **Configuring EBS Volumes in ECS:**
- In the task definition, specify the `mountPoints` field to define where the EBS volume will be mounted inside the container.
- You also need to specify the volume configuration, such as `name`, `host` (for EC2 instances), and `deviceName` (the mount path).

### 2. **EFS (Elastic File System) Volumes**
Amazon EFS is a scalable, elastic file storage system that can be shared between multiple ECS tasks. Unlike EBS, EFS is designed to be accessed concurrently by many tasks and containers, providing a shared file system.

#### **How EFS Works with ECS:**
- EFS can be mounted to containers running in both **ECS EC2** and **Fargate** launch types.
- EFS is ideal when multiple containers need to share data, such as when the containers are processing the same dataset or require access to the same file system.

#### **Configuring EFS Volumes in ECS:**
- In your ECS task definition, you will need to define the EFS volume and specify the mount point inside the container.
- You can use an EFS access point to manage permissions and simplify mounting.


### **Key Differences Between EBS and EFS:**
| Feature                | **EBS (Elastic Block Store)** | **EFS (Elastic File System)** |
|------------------------|-------------------------------|------------------------------|
| **Type of Storage**     | Block Storage (single-instance) | File Storage (multi-instance) |
| **Persistence**         | Persistent until detached or deleted | Persistent, shared across instances |
| **Performance**         | High performance (random read/write) | Scalable, consistent performance |
| **Use Case**            | Ideal for data that is specific to an instance or task (e.g., databases) | Ideal for shared data across multiple containers (e.g., logs, content management) |
| **Access**              | Can be mounted to one instance or task | Can be mounted to multiple instances or tasks |

### **When to Use EBS vs. EFS:**
- **Use EBS** if:
  - You need persistent storage for a specific container or EC2 instance.
  - You require high-performance block-level storage (e.g., for databases or applications that need fast random read/write).
  
- **Use EFS** if:
  - You need to share data across multiple ECS tasks or containers.
  - You require scalable, multi-instance file storage for applications that need access to the same files concurrently.

### **Summary:**
- **EBS** is ideal for storing persistent, instance-specific data.
- **EFS** is suitable for scenarios where you need shared file storage that can be accessed by multiple containers concurrently.
- Both EBS and EFS can be used with ECS tasks to provide persistent storage, but they serve different use cases based on your application's requirements.


*/

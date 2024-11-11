# Create NLB
resource "aws_lb" "nlb" {
  name                       = var.nlb_name
  internal                   = false
  load_balancer_type         = "network"
  subnets                    = var.subnet_ids
  security_groups            = var.security_group_id
  enable_deletion_protection = var.enable_deletion_protection
}

resource "aws_lb_target_group" "target_group" {
  name        = var.target_group_name
  port        = var.target_group_port
  protocol    = var.target_group_protocol
  vpc_id      = var.vpc_id
  target_type = var.target_type

  health_check {
    enabled             = true
    interval            = var.health_check_interval
    port                = "traffic-port"
    protocol            = var.health_check_protocol
    timeout             = var.health_check_timeout
    healthy_threshold   = var.health_check_healthy_threshold
    unhealthy_threshold = var.health_check_unhealthy_threshold
  }
}

# NLB Listener
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = var.listener_port
  protocol          = var.listener_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}

resource "aws_lb_target_group_attachment" "attachment" {
  count            = length(var.attachment_ids)
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = var.attachment_ids[count.index]
  port             = 80
}

/*

Network Load Balancer (NLB) is a load balancing service provided by Amazon Web Services (AWS) designed for applications that require high performance and low latency. 
NLB directs incoming TCP and UDP connections to target groups and maintains connection states by routing to the same target for each connection.

Key features of NLB include:

1. **Low Latency**: NLB provides low-latency response times and high data processing capabilities, making it ideal for performance-demanding applications.

2. **High Scalability**: It can handle millions of requests simultaneously, making it suitable for applications with high traffic volumes.

3. **Static IP Address**: It offers a static IP address per Availability Zone (AZ) or can be assigned an Elastic IP (EIP).

4. **Health Checks**: NLB performs health checks on specified targets to ensure traffic is only directed to healthy targets.

5. **Multi-Protocol Support**: Supports TCP, UDP, and TLS protocols.

6. **Zone Aware**: With multi-AZ support, it optimizes load distribution across zones, reducing excessive traffic to a single AZ.

NLB is especially suitable for applications that require high performance, TCP/UDP-based protocols, and low latency.

A Network Load Balancer (NLB) target group is a configuration that allows the NLB to direct incoming traffic to specific targets, such as EC2 instances or particular IP addresses. 
Through target groups, the NLB routes connections to the correct resources and performs health checks to ensure requests are only directed to healthy targets. 
Here are some details about NLB target groups:

### 1. **Supported Target Types**
   - **EC2 Instances**: NLB target groups are commonly used with EC2 instances as targets.
   - **IP Addresses**: Traffic can be directed to specific IP addresses, including resources outside AWS. This is particularly useful in hybrid cloud environments.
   - **Lambda Functions**: Although primarily used with Application Load Balancers, there are scenarios where NLB can also route to Lambda functions.

### 2. **Port Configuration**
   - NLB target groups allow you to specify the port numbers for the targets. Each connection uses this defined port in the target group.

### 3. **Health Checks**
   - NLB continuously checks the health of the targets. Targets that fail health checks are temporarily removed from receiving traffic, with only healthy targets being used for routing.
   - For health checks, NLB uses the specified port and protocol (TCP, HTTP, etc.), ensuring high availability.

### 4. **Connection Routing and Stability**
   - NLB routes TCP or UDP connections to a specific resource within the target group, and the same target is used for the duration of the connection. This ensures connection stability.
   - Traffic distribution is based on the capacity and load of each target in the group.

### 5. **Availability Zone Support**
   - Target groups can include targets located in multiple Availability Zones, allowing the NLB to distribute traffic across regions for high availability.

### 6. **Using Multiple Target Groups**
   - An NLB can be linked to multiple target groups, enabling traffic to be directed to different target groups based on specified routing rules.

NLB target groups are designed for applications that require high performance, low latency, and high availability.

Yes, Network Load Balancer (NLB) and Application Load Balancer (ALB) can be used together. When combined, these two load balancers provide an effective solution for managing different types of traffic and performance requirements. This combination is ideal for routing TCP/UDP traffic directly through NLB for low-latency connections and for managing HTTP/HTTPS application-layer traffic with ALB.

### Use Cases for Using NLB and ALB Together

1. **Dedicated Load Balancing for Network and Application Layers**:
   - **NLB** handles TCP/UDP traffic, providing fast, low-latency connections. For example, NLB is suitable for applications that need to manage high-volume TCP/UDP traffic with minimal latency.
   - **ALB** works with application-layer (Layer 7) protocols like HTTP/HTTPS, directing traffic based on routing rules and web application needs. 
   This makes ALB ideal for applications requiring session-based routing, detailed routing rules, or URL-based routing.

2. **Distribution Based on Different Traffic Types**:
   - A single application might involve both TCP/UDP and HTTP/HTTPS traffic. For example, a game server could use NLB for TCP traffic while managing HTTP traffic with ALB to optimize performance.

3. **Security and High Availability**:
   - The combination of NLB and ALB provides high availability, especially in multi-region deployments and hybrid cloud environments. They can also be used separately to meet distinct security requirements.

4. **Advanced Routing Scenarios**:
   - While NLB enables direct, low-latency access to resources, ALB can handle more complex routing rules and application-layer functionality. For instance, API traffic can be managed directly through NLB, while web application traffic can be routed via ALB.

Using NLB and ALB together allows for a solution optimized for network-layer and application-layer traffic according to specific needs.

*/

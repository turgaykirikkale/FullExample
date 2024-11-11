resource "aws_lb" "app_lb" {
  name               = var.lb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_group
  subnets            = var.subnets

  enable_deletion_protection       = false
  enable_cross_zone_load_balancing = true

  tags = {
    Name = var.lb_name
  }
}

resource "aws_lb_target_group" "alb_target_group" {
  name     = "app-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_target_group_attachment" "attachment" {
  count            = length(var.attachment_ids)
  target_group_arn = aws_lb_target_group.alb_target_group.arn
  target_id        = var.attachment_ids[count.index]
  port             = 80
}


resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
  }
}

/*

The **Application Load Balancer (ALB)** is one of AWS's load balancing solutions and operates at the application layer (Layer 7),
 designed specifically to manage HTTP and HTTPS traffic. ALB provides a powerful load balancing solution for modern applications, 
 thanks to its variety of features:

### Features of ALB

1. **Host and Path-Based Routing**:
   - ALB can route incoming traffic based on the URL. For example, it can direct traffic to different target groups based on a specific hostname (e.g., `api.example.com`) 
     or a specific path (e.g., `/images` or `/login`).
   - This feature allows you to manage microservices by running each service on a different path through a single ALB.

2. **WebSocket Support**:
   - ALB supports WebSocket and HTTP/2 protocols, enabling efficient traffic management for real-time and highly interactive applications.

3. **Application Health Checks**:
   - ALB only directs traffic to healthy targets. With the health check settings you configure, 
    it automatically monitors which resources are functioning properly and deactivates failed resources.

4. **Dynamic Traffic Distribution**:
   - ALB distributes incoming traffic across target groups based on load, ensuring that servers operate in a balanced way. 
     This optimizes performance and protects overloaded servers from performance degradation.

5. **SSL Certificate Support**:
   - ALB works with SSL/TLS certificates to secure HTTPS connections and integrates with AWS Certificate Manager (ACM) to provide secure connections.

6. **Routing to IPs or Lambda Functions**:
   - ALB can route traffic not only to EC2 instances but also to IP addresses or AWS Lambda functions. 
     This means it can be used in both traditional server-based applications and serverless architectures.

### Benefits of ALB

- **Flexible Routing**: ALB offers URL-based routing, allowing for efficient management of microservices-based applications.
- **Easy Management**: Integrated with AWS, you can easily manage SSL certificates, auto-scaling, and security settings through AWS.
- **Security**: Provides secure connections with SSL/TLS and only routes traffic to healthy targets.

In summary, ALB is a flexible and powerful load balancing service that is particularly suitable for modern web applications or architectures with microservices managing HTTP/HTTPS traffic.

**ALB Target Groups** are logical units within an Application Load Balancer (ALB) that manage traffic routing to various applications or services. 
Target groups define how the ALB distributes incoming traffic to specific targets. 
A target group can include one or more Amazon EC2 instances, IP addresses, or AWS Lambda functions. 
Based on the incoming requests, the ALB dynamically routes traffic to these target groups.

### Features of ALB Target Groups

1. **Load Balancing**:
   - Each target group represents a group of specific targets to be load balanced. 
   ALB distributes incoming traffic across these target groups. For instance, separate target groups can be defined for different components of an application, such as its API and web interface.

2. **Health Checks**:
   - Custom health checks can be configured for each target group. 
    The ALB checks whether the targets are healthy and directs traffic only to healthy ones. 
    Health checks can be configured based on specific paths, response codes, or defined thresholds.

3. **Supported Target Types**:
   - ALB target groups can work with **EC2 instances**, **IP addresses**, and **AWS Lambda functions**, offering flexibility across different target types.
   - For example, target groups can be configured to include only IP addresses, allowing traffic routing to virtual machines or containers (like ECS or Kubernetes pods).

4. **Port and Protocol Support**:
   - Target groups can be configured to work on specific ports and protocols (such as HTTP or HTTPS). 
   This feature allows applications running on different ports to be supported within separate target groups.

5. **Routing Rules**:
   - ALB uses routing rules to direct traffic to different target groups. 
   These rules allow routing based on path, hostname, or header information.
   - For example, requests matching the pattern `/api/*` can be directed to one target group, 
   while requests with `/web/*` are routed to another target group.

### Advantages of ALB Target Groups

- **Flexibility**: They support various target types (EC2, IP, Lambda), making it easier to manage complex infrastructures.
- **High Availability**: Health checks ensure that traffic is routed only to healthy targets, keeping applications running without interruption.
- **Modularity**: Separate target groups can be defined for each component, allowing for customized load balancing per application component.

In summary, ALB target groups allow for optimized load balancing, increased reliability, and improved performance in complex, modern applications by routing incoming traffic to designated target groups.


**ALB Query String Parameters Routing** is a feature of the Application Load Balancer (ALB) that allows you to route incoming requests based on the query string parameters included in the URL. Query strings are the part of a URL that follows a question mark (`?`), and they typically contain key-value pairs (e.g., `?user=123&action=edit`). This feature is particularly useful for directing traffic to different target groups based on specific query string values.

### How Query String Parameters Routing Works

- **Flexible Routing**: With query string parameters routing, you can configure ALB to route requests to different target groups based on the values of specific parameters. 
    For instance, if a request URL is `https://example.com/search?type=product`, ALB can be set to route this request differently than `https://example.com/search?type=category`.
  
- **Complex Applications Support**: This type of routing is especially helpful in applications 
    where different query parameters indicate different services or functions.
    For example, in an e-commerce application, `?item=shoes` could route to a server optimized for handling product pages, while `?action=checkout` could route to a payment processing service.

- **Configuring Routing Rules**: ALB allows you to define rules that inspect incoming requests for specific query string parameters. 
    You can then define how requests with these parameters should be handled, assigning them to appropriate target groups accordingly.

### Benefits of Query String Parameters Routing

1. **Granular Control Over Traffic**: By routing requests based on query parameters, you can direct specific types of traffic to specific target groups, optimizing performance and resources.
2. **Enhanced Application Organization**: Applications with multiple features or services benefit from this routing method, as it allows for distinct handling of different functions within a single application.
3. **Improved User Experience**: Directing traffic based on query string parameters can help ensure that users are served by the most appropriate backend services, leading to faster response times and better overall performance.

In summary, ALB Query String Parameters Routing provides a powerful way to manage and direct HTTP requests based on specific URL parameters, making it ideal for applications with varied services that rely on query string data for routing logic.

*/

# Creating dynamically private or public route table 
resource "aws_route_table" "route_table" {
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    gateway_id     = var.internet_gateway_id != null ? var.internet_gateway_id : null
    nat_gateway_id = var.nat_gateway_id != null ? var.nat_gateway_id : null
  }
  tags = {
    Name = "${var.rt_name}/ ${var.vpc_id}"
  }
}

# Associating Subnet with Route Table
resource "aws_route_table_association" "dynamic_association" {

  subnet_id      = var.subnet_id
  route_table_id = aws_route_table.route_table.id
}


/*
Route Table is a component used in Amazon Web Services (AWS) to manage traffic routing within a Virtual Private Cloud (VPC).
 Route tables determine how traffic is directed from resources within the VPC (e.g., EC2 instances) to its intended destination.

Features of a Route Table
Network Routing: A route table specifies how traffic destined for a specific IP address or CIDR block should be routed. 
This allows resources to communicate with the internet or other VPC components.

CIDR Notation: Targets in the route table are usually defined using CIDR (Classless Inter-Domain Routing) notation.
 For example, a target like 10.0.0.0/16 represents a specific range of IP addresses.

Default Route: Route tables typically include a default route that specifies where traffic that does not match any known targets should be sent.
 This is often represented as 0.0.0.0/0, which indicates all internet traffic.

Multiple Route Tables: AWS allows you to create multiple route tables for each VPC. 
This enables you to implement different routing strategies for various subnets.

Why Use Route Tables?
Provide Internet Access: A route table allows internet access via a public subnet connected to an IGW (Internet Gateway).
 The route table directs the target 0.0.0.0/0 to the IGW.

Facilitate Communication: Route tables are used to facilitate communication within the VPC, between subnets, or with other networks outside the VPC. 
For example, if resources in a private subnet need to connect to another network via a VPN, the route table specifies the appropriate target.

Security and Control: Route tables help control which paths traffic will take, aiding in the implementation of network security strategies. 
Determining which traffic is allowed and which routes to use is critical for network architecture.

Application Performance: Well-configured route tables can help route network traffic more quickly and efficiently, potentially enhancing application performance.

Example Use Case
Suppose you have a web application hosted on AWS. To enable users to access your application, you would create an IGW within a public subnet and establish a route table linked to it. By routing the target 0.0.0.0/0 to the IGW, you would facilitate internet access.
Conclusion
A route table is a critical component for managing traffic routing in AWS. When configured correctly, it allows resources within the VPC to communicate securely and efficiently. If you have further questions or need information about a specific use case, I'd be happy to help!
*/

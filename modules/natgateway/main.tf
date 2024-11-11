
resource "aws_eip" "nat_gateway_eip" {
  count      = length(var.public_subnet_ids)
  domain     = "vpc"
  tags = {
    Name = "igw_eip_${count.index}"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  count         = length(var.public_subnet_ids)
  allocation_id = aws_eip.nat_gateway_eip[count.index].id
  subnet_id     = var.public_subnet_ids[count.index]
  tags          = var.tags
}


/*
Why Should I Use a NAT Gateway?
Using a NAT Gateway has several important advantages and use cases. Here are some reasons:

1. Internet Access for Resources in Private Subnets
A NAT Gateway allows resources in private subnets (such as EC2 instances) to access the outside world (the internet). 
This is essential for updates, API calls, or accessing other internet resources.

2. IP Address Privacy
With a NAT Gateway, resources in private subnets can hide their private IP addresses when accessing the internet, which is important for security. 
The NAT Gateway does not accept incoming traffic, so private resources remain inaccessible from the outside.

3. High Scalability and Reliability
As a managed service by AWS, the NAT Gateway is automatically scalable and provides high availability. 
Users can focus on using their resources without worrying about infrastructure management and maintenance processes.

4. Static IP for Internet Access
Since the NAT Gateway is associated with an Elastic IP, all internet traffic is routed through a specific IP address. 
This is beneficial for systems or applications that rely on a specific IP address.

5. Easy Management
NAT Gateways can be easily created and managed through the AWS Management Console or tools like Terraform. 
Users can simply create a NAT Gateway and route it to the necessary subnets to enable internet access.

6. Better Security Controls
NAT Gateways automatically block incoming traffic (inbound) while managing outbound (egress) traffic, 
providing greater protection against external attacks. This is a critical advantage for overall security posture.

7. Performance
NAT Gateways offer high performance due to load balancing and automatic scaling features. 
They can handle high traffic volumes and provide uninterrupted service.

Example Use Cases
Access for Updates: When a database server needs internet access for software updates or dependencies, a NAT Gateway is used.
API Calls: Applications located in private subnets can use a NAT Gateway to send or receive data from external APIs.
Data Backup: NAT Gateways can be utilized when resources in private subnets need access to backup or storage services.
For these reasons, the NAT Gateway is an important component for securely and efficiently enabling internet access for private resources on AWS.
*/

resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id

  tags = {
    Name = "igw-${var.vpc_name}"
  }
}


/*
Internet Gateway (IGW) is a component in Amazon Web Services (AWS) that allows a Virtual Private Cloud (VPC) to communicate with the outside world. 
IGW enables resources within the VPC (e.g., EC2 instances) to access the internet.

Features of IGW
Public IP Addresses: IGW allows communication with the internet through publicly assigned IP addresses for the VPC. 
Resources within the VPC can receive requests from the internet and can also send requests out to the internet.

Load Balancing: IGW provides internet access to multiple resources connected to a VPC across several subnets. 
It can work alongside load balancing services (like Elastic Load Balancer).

Dynamic and Static: IGW can work with both dynamic (e.g., Elastic IP) and static IP addresses.

Traffic Management: IGW manages the incoming and outgoing internet traffic. 
Proper settings in route tables are needed for traffic routing for the resources within the VPC.

Why Use IGW?
Provide Internet Access: IGW is used to allow resources within a VPC (e.g., web servers) to communicate with the internet. 
This facilitates user access to web applications and services.

Security and Control: IGW allows the VPC to connect to the outside world, but this access is controlled through security groups and route tables.
 This helps in managing internet access securely.

Load Balancing and Scalability: IGW, when used in conjunction with other AWS services, enhances the scalability of applications. 
For instance, it can enable load balancing for multiple EC2 instances to achieve better performance.

Application Performance: IGW improves the response times of applications. 
When configured correctly, incoming requests from the outside world can be processed quickly.

Example Use Case
You have a web application hosted on EC2 instances. To allow users to access your application over the internet, 
you create an IGW in your VPC and configure the route tables to use this IGW to facilitate internet access.

Conclusion
IGW is a critical component that manages the internet interaction of an AWS VPC. When configured correctly, it allows your resources to access the internet securely and enhances application performance. If you have more questions or need information about a specific use case, I’d be happy to help!
*/
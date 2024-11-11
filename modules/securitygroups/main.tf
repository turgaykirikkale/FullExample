resource "aws_security_group" "security_group" {
  name        = var.sg_name
  description = var.description
  vpc_id      = var.vpc_id

  // Inbound Rules
  ingress {
    from_port       = var.ingress_from_port
    to_port         = var.ingress_to_port
    protocol        = var.ingress_protocol
    cidr_blocks     = length(var.ingress_cidr_blocks) > 0 ? var.ingress_cidr_blocks : null
    security_groups = length(var.ingress_sg) > 0 ? var.ingress_sg : null
  }

  egress {
    from_port   = var.engress_from_port
    to_port     = var.engress_to_port
    protocol    = var.engress_protocol
    cidr_blocks = var.engress_cidr_blocks
  }

}

/*

 Security groups are "Firewall" for our EC2 Instances.

 they regulate : 
 -Access ports
 -Authorized IP ranges IPv4 or IPv6
 -Control inbound network(from other to EC2 instance)
 -Control outbound network(from EC2 instance to other)

 Attributes: 
 -Can attached to multiple instances.
 -Locked down to a region/VPC combination.
 - Does live "outside of EC2 - if traffic blocked the EC2 instane wont see it."
 -it is good to maintain one seperate security group for SSH acces.
 -if your application is not accessible(time out), then it's a security group issue.
 -if your application gives a "connection refused" error, then it's application error or its not launched.

HTTP	80	Web trafiği için standart port.
HTTPS	443	Güvenli web trafiği için.
FTP	21	Dosya aktarımı için.
SFTP	22	Güvenli dosya aktarımı için.
SSH	22	Uzaktan yönetim için.
Telnet	23	Uzaktan yönetim için (güvensiz).
SMTP	25	E-posta gönderimi için.
POP3	110	E-posta alımı için (güvensiz).
IMAP	143	E-posta alımı için (güvenli).
MySQL	3306	MySQL veritabanı için.
PostgreSQL	5432	PostgreSQL veritabanı için.
Microsoft SQL Server	1433	MS SQL Server için.
Redis	6379	Redis veritabanı için.
Cassandra	9042	Apache Cassandra için.
RabbitMQ	5672	RabbitMQ mesajlaşma için.
Elasticsearch	9200	Elasticsearch sorguları için.
MongoDB	27017	MongoDB veritabanı için.
RDP	3389	Uzak masaüstü bağlantısı için.
DNS	53	Alan adı sistemleri için.
DHCP	67, 68	Dinamik IP adresi dağıtımı için.
NTP	123	Zaman senkronizasyonu için.
SNMP	161	Ağ izleme ve yönetimi için.
LDAP	389	Dizin hizmetleri için.

In AWS, a Security Group can be attached to various resources to control network access to them. Commonly, Security Groups can be attached to the following resources:

EC2 Instances: Security Groups are used to secure EC2 instances by defining which IPs and ports can access the instance.
Elastic Load Balancer (ELB): Attaching a Security Group to an ELB helps set security policies for incoming and outgoing traffic.
RDS (Relational Database Service): Security Groups are attached to databases to allow access only from specific IPs or VPCs.
Elastic File System (EFS): Security Groups control access to EFS to restrict network access to the file system.
Lambda (within a VPC): If a Lambda function is within a VPC, you can define access policies with a Security Group.
Redshift Cluster: Security Groups can be attached to Amazon Redshift clusters to restrict network access to the data warehouse.
Properly configuring Security Groups for these resources is crucial for securing network access and protecting your resources.
*/


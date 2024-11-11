provider "aws" {
  region = "us-east-1"
  //environment Access ve Secret Acces Key
 
}
data "aws_availability_zones" "available" {}
data "aws_region" "current" {}

locals {
  vpc_cidr = "10.0.0.0/16"
  public_subnet_cidrs = { for idx, az in data.aws_availability_zones.available.names :
  az => cidrsubnet(local.vpc_cidr, 8, idx) }                              # Public subnet CIDR blocks
  private_subnet_cidrs = ["10.0.15.0/24", "10.0.16.0/24", "10.0.17.0/24"] # Private subnet CIDR blocks
  availability_zones   = data.aws_availability_zones.available.names      // AZ for my subnets.
}

module "vpc" {
  source         = "./modules/vpc"
  vpc_name       = "000001"
  vpc_cidr_block = local.vpc_cidr
}

//We create Subnets for handle network more easy.


module "public_subnets" {
  for_each                = local.public_subnet_cidrs
  source                  = "./modules/subnet"
  name                    = "public_${each.key}"
  environment             = "dev"
  availability_zone       = each.key
  vpc_id                  = module.vpc.vpc_id
  cidr_block              = each.value
  map_public_ip_on_launch = true
}

module "private_subnets" {
  count             = length(local.private_subnet_cidrs)
  source            = "./modules/subnet"
  name              = "private${count.index}"
  environment       = "dev"
  availability_zone = local.availability_zones[count.index]
  vpc_id            = module.vpc.vpc_id
  cidr_block        = local.private_subnet_cidrs[count.index]
}

//I need to have to put IGW for my VPC for connection to the ınternet for VPC 

module "internet_gateway" {
  source   = "./modules/igw"
  vpc_name = module.vpc.name
  vpc_id   = module.vpc.vpc_id
}

//Outbound internet access for my resources in private subnets is provided by the created NAT Gateway.
module "natgateway" {
  source            = "./modules/natgateway"
  public_subnet_ids = [for subnet in module.public_subnets : subnet.subnet_id]
  internet_gateway  = module.internet_gateway.igw_id
  tags = {
    Name = "NatGateway_${module.vpc.name}"
  }
}

module "public_route_table" {
  for_each            = module.public_subnets
  source              = "./modules/routetable"
  vpc_id              = module.vpc.vpc_id
  rt_name             = "publicRT_${each.value.subnet_name}"
  internet_gateway_id = module.internet_gateway.igw_id
  subnet_id           = each.value.subnet_id
}

module "private_route_tabLe" {
  count          = length(module.private_subnets)
  source         = "./modules/routetable"
  vpc_id         = module.vpc.vpc_id
  rt_name        = "privateRT_${module.private_subnets[count.index].subnet_name}"
  nat_gateway_id = module.natgateway.nat_gateway_ids[count.index % length(module.natgateway.nat_gateway_ids)]
  subnet_id      = module.private_subnets[count.index].subnet_id
}

/*

S3 was created and replication created, and SNS email system was established.

module "s3" {
  source             = "./modules/s3"
  bucket_name        = "s3-bucket-v00001"
  versioning         = true
  sns_topic_arn      = module.sns.sns_topic_arn     # İsteğe bağlı
  notification_email = "turgykirikkale@hotmail.com" # İsteğe bağlı
}

module "s3replication" {
  source                  = "./modules/s3replication"
  source_bucket_arn       = module.s3.bucket_arn
  source_bucket_name      = module.s3.bucket_name
  source_bucket_id        = module.s3.bucket_id
  destination_bucket_name = "replica-${module.s3.bucket_name}"
}


module "sns" {
  source             = "./modules/sns"
  sns_topic_name     = "s3-event-notifications-topic" # Optional
  s3_bucket_arn      = module.s3.bucket_arn           # optional
  notification_email = "turgaykirikkale@hotmail.com"  #Optional
}
*/

module "security_group_http" {
  source              = "./modules/securitygroups"
  sg_name             = "Sg_${module.vpc.name}_http"
  description         = "Security group for web servers"
  vpc_id              = module.vpc.vpc_id
  ingress_from_port   = 80
  ingress_to_port     = 80
  ingress_protocol    = "tcp"
  ingress_cidr_blocks = ["0.0.0.0/0"]
}

module "security_group_https" {
  source              = "./modules/securitygroups"
  sg_name             = "Sg_${module.vpc.name}_https"
  description         = "Security group for web servers"
  vpc_id              = module.vpc.vpc_id
  ingress_from_port   = 443
  ingress_to_port     = 443
  ingress_protocol    = "tcp"
  ingress_cidr_blocks = ["0.0.0.0/0"]
}


module "security_group_ssh" {
  source              = "./modules/securitygroups"
  sg_name             = "Sg_${module.vpc.name}_ssh"
  description         = "Security group for ssh"
  vpc_id              = module.vpc.vpc_id
  ingress_from_port   = 22
  ingress_to_port     = 22
  ingress_protocol    = "tcp"
  ingress_cidr_blocks = ["0.0.0.0/0"]
}


module "security_group_private" {
  source              = "./modules/securitygroups"
  sg_name             = "Sg_${module.vpc.name}_private"
  description         = "Security group for ssh"
  vpc_id              = module.vpc.vpc_id
  ingress_from_port   = 22
  ingress_to_port     = 22
  ingress_protocol    = "tcp"
  ingress_cidr_blocks = ["${module.public_instance.instance_private_ip}/32"]
}



#We used public instance for reaching private instance

module "public_instance" {
  source              = "./modules/ec2"
  ami_name            = "amazon_linux"
  instance_type       = "t2.micro"
  subnet_id           = module.public_subnets[keys(module.public_subnets)[0]].subnet_id
  instance_name       = "public_instance_${module.vpc.name}"
  use_security_groups = ["${module.security_group_http.sg_id}", "${module.security_group_https.sg_id}", "${module.security_group_ssh.sg_id}"]
  user_data_script    = <<-EOF
              #!/bin/bash
              # Use this for your user data (script from top to bottom)
              # install httpd (Linux 2 version)
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Hello World from $(hostname -f)</h1>" > /var/www/html/index.html
              EOF
}

module "private_instace" {
  source              = "./modules/ec2"
  ami_name            = "amazon_linux"
  instance_type       = "t2.micro"
  instance_name       = "private_instance_${module.vpc.name}"
  subnet_id           = module.private_subnets[0].subnet_id
  use_security_groups = [module.security_group_private.sg_id]
}



/*
module "spot_instance" {
  source              = "./modules/ec2"
  ami_name            = "centos"
  subnet_id           = module.public_subnets[keys(module.public_subnets)[1]].subnet_id
  instance_name       = "spot_instance"
  instance_type       = "t2.micro"
  spot_price          = "0.007"
  use_security_groups = ["${module.security_group_http.sg_id}", "${module.security_group_https.sg_id}", "${module.security_group_ssh.sg_id}"]
}
*/

/*

PLACEMENT GROUP EXAMPLE


module "placementgroup_spread" {
  source                   = "./modules/placementgroup"
  placement_group_name     = "spread_1"
  placement_group_strategy = "spread"
}

module "placement_gr_spread_instance" {
  for_each            = module.public_subnets
  placementgroup_name = module.placementgroup_spread.placegroup_name
  source              = "./modules/ec2"
  ami_name            = "ubuntu"
  subnet_id           = each.value.subnet_id
  instance_name       = "spread_${each.value.subnet_name}"
  instance_type       = "t2.micro"
  use_security_groups = ["${module.security_group_http.sg_id}", "${module.security_group_https.sg_id}", "${module.security_group_ssh.sg_id}"]
  availability_zone   = each.key
}

module "placement_gr_cluster_instance" {
  count                    = 3
  placement_group_name     = "cluster_${count.index + 1}"
  placement_group_strategy = "cluster"
  source                   = "./modules/ec2"
  ami_name                 = "centos"
  subnet_id                = module.public_subnets[keys(module.public_subnets)[2]].subnet_id
  instance_name            = "cluster_${count.index + 1}"
  instance_type            = "m5.large"
  use_security_groups = ["${module.security_group_http.sg_id}", "${module.security_group_https.sg_id}", "${module.security_group_ssh.sg_id}"]
}

*/




/*
#EBS- EBS SNAPSHOT EXAMPLE

module "ebs" {
  source            = "./modules/ebs"
  availability_zone = local.availability_zones[0]
  volume_name       = "ebs_${local.availability_zones[0]}"
}

module "EC2_instance_with_ebs" {
  source              = "./modules/ec2"
  ami_name            = "amazon_linux"
  instance_type       = "t2.micro"
  subnet_id           = module.public_subnets[keys(module.public_subnets)[0]].subnet_id
  instance_name       = "ebs_instance_${local.availability_zones[0]}"
  use_security_groups = ["${module.security_group_http.sg_id}", "${module.security_group_https.sg_id}", "${module.security_group_ssh.sg_id}"]
  user_data_script    = <<-EOF
              #!/bin/bash
              sudo mkfs -t ext4 /dev/xvdh
              sudo mkdir /var/www/html
              sudo mount /dev/xvdh /var/www/html
              echo "<html><body><h1>Merhaba Dünya</h1></body></html>" | sudo tee /var/www/html/index.html
              sudo yum install -y httpd
              sudo systemctl start httpd
              sudo systemctl enable httpd
              EOF
}

resource "aws_volume_attachment" "ebs_attachment" {
  device_name = "/dev/xvdh"
  volume_id   = module.ebs.ebs_id
  instance_id = module.EC2_instance_with_ebs.instance_id
}

module "ebs_snapshot" {
  source                      = "./modules/ebs_snapshot"
  volume_id                   = module.ebs.ebs_id
  description                 = "My EBS snapshot"
  encrypted                   = true
  create_volume_from_snapshot = true
  size                        = 20
  availability_zone           = "us-east-1a"
  snapshot_name               = "${module.ebs.ebs_name}_snapshot"
}

output "ebs_id" {
  value = module.ebs.ebs_id
}
output "ebs_name" {
  value = module.ebs.ebs_name
}

output "ebs_snapshot_id" {
  value = module.ebs_snapshot.snapshot_id
}

output "restored_volume_id" {
  value = module.ebs_snapshot.restored_volume_id
}
*/



/*
#CUSTOM AMI EXANPLE

module "base_instance_for_ami" {
  source              = "./modules/ec2"
  ami_name            = "amazon_linux"
  instance_type       = "t2.micro"
  subnet_id           = module.public_subnets[keys(module.public_subnets)[0]].subnet_id
  instance_name       = "custom_ami_${local.availability_zones[0]}"
  use_security_groups = ["${module.security_group_http.sg_id}", "${module.security_group_https.sg_id}", "${module.security_group_ssh.sg_id}"]
  user_data_script    = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              EOF
}

module "custom_ami_1" {
  source           = "./modules/ami"
  base_instance_id = module.base_instance_for_ami.instance_id
}

module "instance_from_ami" {
  source              = "./modules/ec2"
  custom_ami_id       = module.custom_ami_1.custom_ami_id
  instance_type       = "t2.micro"
  subnet_id           = module.public_subnets[keys(module.public_subnets)[0]].subnet_id
  instance_name       = "created_fromcustom_ami_${local.availability_zones[0]}"
  use_security_groups = ["${module.security_group_http.sg_id}", "${module.security_group_https.sg_id}", "${module.security_group_ssh.sg_id}"]
  user_data_script    = <<-EOF
              #!/bin/bash
              echo "Hello from Apache on Amazon Linux" > /var/www/html/index.html
              EOF
}

output "custom_ami_id" {
  value = module.custom_ami_1.custom_ami_id
}
*/


/*
#EFS EXAMPLE

module "sg_efs" {
  source              = "./modules/securitygroups"
  sg_name             = "Sg_${module.vpc.name}_efs"
  description         = "Security group for efs"
  vpc_id              = module.vpc.vpc_id
  ingress_from_port   = 2049
  ingress_to_port     = 2049
  ingress_protocol    = "tcp"
  ingress_cidr_blocks = ["0.0.0.0/0"]
}

module "efs" {
  source            = "./modules/efs"
  security_group_id = module.sg_efs.sg_id
  vpc_id            = module.vpc.vpc_id
  subnet_ids        = [for subnet in module.public_subnets : subnet.subnet_id]
}

output "efs_id" {
  value = module.efs.efs_id
}
output "efs_mount_target" {
  value = module.efs.mount_targets
}
*/


/*
#ELB-ALB örneği

module "sg_alb" {
  source              = "./modules/securitygroups"
  sg_name             = "Sg_${module.vpc.name}_alb"
  description         = "Security group for alb"
  vpc_id              = module.vpc.vpc_id
  ingress_from_port   = 80
  ingress_to_port     = 80
  ingress_protocol    = "tcp"
  ingress_cidr_blocks = ["0.0.0.0/0"]
}

module "sg_allow_alb" {
  source            = "./modules/securitygroups"
  sg_name           = "Sg_${module.vpc.name}_allow_alb"
  description       = "Security group for allow alb"
  vpc_id            = module.vpc.vpc_id
  ingress_from_port = 80
  ingress_to_port   = 80
  ingress_protocol  = "tcp"
  ingress_sg        = [module.sg_alb.sg_id]
}


module "ec2_first" {
  source              = "./modules/ec2"
  ami_name            = "amazon_linux"
  instance_type       = "t3.micro"
  instance_name       = "first_alb_instance"
  subnet_id           = module.public_subnets[keys(module.public_subnets)[0]].subnet_id
  use_security_groups = [module.sg_allow_alb.sg_id]
  user_data_script    = <<-EOF
              #!/bin/bash
              # Use this for your user data (script from top to bottom)
              # install httpd (Linux 2 version)
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Hello World from $(hostname -f)</h1>" > /var/www/html/index.html
              EOF
}

module "ec2_second" {
  source              = "./modules/ec2"
  ami_name            = "amazon_linux"
  instance_type       = "t2.micro"
  instance_name       = "second_alb_instance"
  subnet_id           = module.public_subnets[keys(module.public_subnets)[0]].subnet_id
  use_security_groups = [module.sg_allow_alb.sg_id]
  user_data_script    = <<-EOF
              #!/bin/bash
              # Use this for your user data (script from top to bottom)
              # install httpd (Linux 2 version)
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Hello World from $(hostname -f)</h1>" > /var/www/html/index.html
              EOF
}


module "alb" {
  source         = "./modules/elb/alb"
  lb_name        = "albfirst"
  subnets        = ["${module.public_subnets[keys(module.public_subnets)[0]].subnet_id}", "${module.public_subnets[keys(module.public_subnets)[1]].subnet_id}"]
  security_group = ["${module.sg_alb.sg_id}"]
  vpc_id         = module.vpc.vpc_id
  attachment_ids = ["${module.ec2_first.instance_id}", "${module.ec2_second.instance_id}"]
}


output "alb_dns_name" {
  value = module.alb.alb_dns_name
}
*/


/*
#ELB-NLB EXAMPLE

module "sg_nlb" {
  source              = "./modules/securitygroups"
  sg_name             = "Sg_${module.vpc.name}_nlb"
  description         = "Security group for nlb"
  vpc_id              = module.vpc.vpc_id
  ingress_from_port   = 80
  ingress_to_port     = 80
  ingress_protocol    = "tcp"
  ingress_cidr_blocks = ["0.0.0.0/0"]
}

module "sg_allow_nlb" {
  source            = "./modules/securitygroups"
  sg_name           = "Sg_${module.vpc.name}_allow_nlb"
  description       = "Security group for allow nlb"
  vpc_id            = module.vpc.vpc_id
  ingress_from_port = 80
  ingress_to_port   = 80
  ingress_protocol  = "tcp"
  ingress_sg        = [module.sg_nlb.sg_id]
}

module "target_ec2" {
  count               = 3
  source              = "./modules/ec2"
  ami_name            = "amazon_linux"
  instance_type       = "t3.micro"
  instance_name       = "nlb_instance_${count.index}"
  subnet_id           = module.public_subnets[keys(module.public_subnets)[count.index]].subnet_id
  use_security_groups = [module.sg_allow_nlb.sg_id]
  user_data_script    = <<-EOF
              #!/bin/bash
              # Use this for your user data (script from top to bottom)
              # install httpd (Linux 2 version)
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Hello World from $(hostname -f)</h1>" > /var/www/html/index.html
              EOF
}

module "nlb" {
  source            = "./modules/elb/nlb"
  nlb_name          = "nlbfirst"
  security_group_id = ["${module.sg_nlb.sg_id}"]
  vpc_id            = module.vpc.vpc_id
  target_group_name = "EC2targets"
  subnet_ids        = ["${module.public_subnets[keys(module.public_subnets)[0]].subnet_id}", "${module.public_subnets[keys(module.public_subnets)[1]].subnet_id}", "${module.public_subnets[keys(module.public_subnets)[2]].subnet_id}"]
  target_group_port = 80
  attachment_ids    = module.target_ec2[*].instance_id
}

output "alb_dns_name" {
  value = module.nlb.alb_dns_name
}
*/


/*
#ASG EXAMPLE WITH EC2 CONNECTIONS
module "asg" {
  source          = "./modules/asg"
  template_name   = "template_base"
  security_groups = ["${module.security_group_http.sg_id}"]
  subnet_ids      = ["${module.public_subnets[keys(module.public_subnets)[0]].subnet_id}", "${module.public_subnets[keys(module.public_subnets)[1]].subnet_id}", "${module.public_subnets[keys(module.public_subnets)[2]].subnet_id}"]
  instance_type   = "t2.micro"
  ami_id          = "ami-063d43db0594b521b"
  asg_name        = "asg_with_EC2"
}

*/


/*
#ASG EXAMPLE WITH ALB 
module "sg_alb" {
  source              = "./modules/securitygroups"
  sg_name             = "Sg_${module.vpc.name}_alb"
  description         = "Security group for alb"
  vpc_id              = module.vpc.vpc_id
  ingress_from_port   = 80
  ingress_to_port     = 80
  ingress_protocol    = "tcp"
  ingress_cidr_blocks = ["0.0.0.0/0"]
}

module "sg_allow_alb" {
  source            = "./modules/securitygroups"
  sg_name           = "Sg_${module.vpc.name}_allow_alb"
  description       = "Security group for allow alb"
  vpc_id            = module.vpc.vpc_id
  ingress_from_port = 80
  ingress_to_port   = 80
  ingress_protocol  = "tcp"
  ingress_sg        = [module.sg_alb.sg_id]
}

module "alb" {
  source         = "./modules/elb/alb"
  lb_name        = "albfirst"
  subnets        = ["${module.public_subnets[keys(module.public_subnets)[0]].subnet_id}", "${module.public_subnets[keys(module.public_subnets)[1]].subnet_id}"]
  security_group = ["${module.sg_alb.sg_id}"]
  vpc_id         = module.vpc.vpc_id
}


module "asg" {
  source            = "./modules/asg"
  template_name     = "template_base"
  security_groups   = ["${module.sg_allow_alb.sg_id}"]
  subnet_ids        = ["${module.public_subnets[keys(module.public_subnets)[0]].subnet_id}", "${module.public_subnets[keys(module.public_subnets)[1]].subnet_id}", "${module.public_subnets[keys(module.public_subnets)[2]].subnet_id}"]
  instance_type     = "t2.micro"
  ami_id            = "ami-063d43db0594b521b"
  asg_name          = "asg_with_ELB"
  health_check_type = "ELB"
  target_group_arn  = ["${module.alb.target_group_arn}"]
}

*/




output "subnet_public" {
  value = module.public_subnets
}

output "subnet_private" {
  value = module.private_subnets[*].subnet_id
}
output "nat_gateway_ids" {
  value = module.natgateway.nat_gateway_ids
}

output "AZ" {
  value = data.aws_availability_zones.available.names
}

output "public_cidr" {
  value = local.public_subnet_cidrs
}

output "public_instance_ip" {
  value = module.public_instance.instance_private_ip
}




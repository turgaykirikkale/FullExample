resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name        = var.vpc_name
    Environment = "${var.vpc_name}dev"
    Terraform   = "true"
  }
}

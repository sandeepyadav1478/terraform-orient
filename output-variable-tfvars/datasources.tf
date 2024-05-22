data "aws_ami" "regional_ubuntu_ami" {
  most_recent = true
  owners = [ "amazon" ]

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu*"]  # Filter by Ubuntu image name pattern
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


data "aws_vpc" "regional_default" {
  filter {
    name = "is-default"
    values = [ "true" ]
  }

  filter{
    name = "cidr-block"
    values = [ "172.31.0.0/16" ]
  }
}

data "aws_subnets" "default_public_subnets" {

  # Filter by subnet that has a route table with a route to an internet gateway
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.regional_default.id]
  }

  tags = {
    Tier = "Public"
  }
}


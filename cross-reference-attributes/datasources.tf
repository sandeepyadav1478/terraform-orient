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

# Getting current vpc
data "aws_vpc" "practo_vpc" {
  id = aws_security_group.practo_access.vpc_id
}
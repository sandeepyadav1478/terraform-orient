# EIP for ssh only
resource "aws_eip" "https_eip" {
  domain = "vpc"

  # IP adertisement location
  network_border_group = var.primary_region

  # Application Tags
  tags = {
    service = "billing"
  }

  timeouts {
    # Updating default timeouts of 20m
    read = "5m"
  }
}

# SG for allowing ssh from EIP
resource "aws_security_group" "practo_access" {
  name = "SSH from eip cidr only"
  description = "We are making ssh to bound, to only 1 Public IP. No other ip should ssh."

  lifecycle {
    create_before_destroy = true
  }

  timeouts {
    delete = "2m"
  }
  
}

# Ingress rule EIP
resource "aws_vpc_security_group_ingress_rule" "ssh_rule_eip" {
  security_group_id = aws_security_group.practo_access.id

  cidr_ipv4   = "${aws_eip.https_eip.public_ip}/32"
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
}

resource "aws_vpc_security_group_ingress_rule" "ssh_rule_all" {
  security_group_id = aws_security_group.practo_access.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
}


# Ingress for allow http from anywhere
resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv4" {
  security_group_id = aws_security_group.practo_access.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}

# Egress for Internet Resource access
resource "aws_vpc_security_group_egress_rule" "allow_internet_tcp" {
  security_group_id = aws_security_group.practo_access.id

  cidr_ipv4 = "0.0.0.0/0"
  from_port = 0
  ip_protocol = "tcp"
  to_port = 0
}

locals {
  practo_vpc_id = aws_security_group.practo_access.vpc_id
  practo_vpc_arn = data.aws_vpc.practo_vpc.arn
}

# EC2 that have SSH EIP SG applied on it
resource "aws_instance" "practo_web" {
  ami = data.aws_ami.regional_ubuntu_ami.id
  instance_type = var.instance_type
  # associate_public_ip_address = aws_eip.billing_eip.address
  security_groups = [ aws_security_group.practo_access.name ]
  user_data = <<-EOF
    #!bin/bash
    apt update
    apt install -y nginx
    sudo systemctl start nginx
    sudo systemctl enable nginx
    echo "practo-web" | sudo tee /etc/hostname
    hostname -F /etc/hostname
    echo "<h1>SG exists inside ${local.practo_vpc_arn}</h1>" | sudo tee /var/www/html/index.nginx-debian.html
  EOF

  tags = {
    Name = "practo_web",
    Group = "devs",
    desired_region = var.primary_region
  }

}
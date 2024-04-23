resource "aws_vpc" "demo_vpc" {
  cidr_block = "10.0.0.0/28"

  instance_tenancy = "default"

  tags = {
    Name = "demo",
    type = "practo",
    service = "security"
  }
}


# HTTPS Security group
resource "aws_security_group" "allow_tls_sg" {
  name = "allow_tls_sg"
  # name_prefix = "practo"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id = aws_vpc.demo_vpc.id

  tags = {
    Name = "allow_tls"
  }

  lifecycle {
    create_before_destroy = true
  }

  timeouts {
    delete = "2m"
  }
}

# Inbound IPV4 HTTPS
resource "aws_security_group_rule" "allow_tls_ipv4_rule" {
  type = "ingress"
  security_group_id = aws_security_group.allow_tls_sg.id
  cidr_blocks = [aws_vpc.demo_vpc.cidr_block]
  from_port = 443
  protocol = "tcp"
  to_port = 443
  
  timeouts {
    create = "5m"
  }
}

# Outbound IPV4 HTTPS
resource "aws_security_group_rule" "allow_all_traffic_ipv4" {
  type = "egress"
  security_group_id = aws_security_group.allow_tls_sg.id
  cidr_blocks = [aws_vpc.demo_vpc.cidr_block]
  protocol = "all"
  from_port = 0
  to_port = 0

  timeouts {
    create = "5m"
  }
}
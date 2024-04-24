# Demo application EC2
resource "aws_instance" "practo_web" {
  ami = data.aws_ami.regional_ubuntu_ami.id
  instance_type = var.default_instance_type
  associate_public_ip_address = aws_eip.billing_eip.address

  tags = {
    Name = "practo_web",
    desired_region = var.primary_region
  }
}



# Elastic ip for ec2
resource "aws_eip" "billing_eip" {
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
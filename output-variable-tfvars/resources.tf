resource "aws_instance" "elb_instance" {
    ami = data.aws_ami.regional_ubuntu_ami.id
    instance_type = "t2.micro"

    lifecycle {
        # Ami id of `x86_64` os architecture 
        precondition {
          condition = data.aws_ami.regional_ubuntu_ami.architecture == "x86_64"
          error_message = "The selected AMI must be for the x86_64 architecture."
        }
    
        # The EC2 instance must be allocated a public dns hostname\
        postcondition {
          condition = self.public_dns != ""
          error_message = "EC2 instance must be in a VPC that has public DNS hostname enabled."
        }
    }
}


# Load balancer for traffic control
resource "aws_lb" "traffic_controller" {
  name = "ec2-frontier"
  internal = false
  load_balancer_type = "application"

  security_groups = [ aws_security_group.alb_sb.id ]
  subnets = [ data.aws_subnets.default_public_subnets.ids.0, data.aws_subnets.default_public_subnets.ids.1 ]
  

  enable_deletion_protection = false

  tags = {
    env = "development",
    Name = "ec2-frontier"
  }

  depends_on = [ aws_security_group.alb_sb ]

}

# ALB security group
resource "aws_security_group" "alb_sb" {
  name = "ALB_SG_allow_http"
  description = "Security group for load balancer, for incoming traffic to nginx"

  tags = {
    Name = "ALB_SG_allow_http"
  }
}


# Target group for that load balancer
resource "aws_lb_target_group" "alb_tg_http" {
  name = "tf-http-ec2"
  port = 80
  protocol = "HTTP"
  target_type = "instance"

  target_health_state {
    enable_unhealthy_connection_termination = false
  }

}
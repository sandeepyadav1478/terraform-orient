output "public_ip_ec2" {
  value = "http://${aws_instance.practo_web.public_ip}"
}

output "VPC_used" {
  value = local.practo_vpc_id
}
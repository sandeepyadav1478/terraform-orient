# output "current_region" {
#   value = var.primary_region
# }

output "elb_instance_volume_encryption_status" {
  value = "EBS volume not encrypted ${aws_instance.elb_instance.root_block_device.0.volume_id}"
  description = "Check the status of ecryption on ec2 default attached volume"
  
  depends_on = [ aws_instance.elb_instance ]

  precondition {
    condition = aws_instance.elb_instance.root_block_device.0.encrypted == false
    error_message = "Storage is not encrypted."
  }
}

output "elb_instance_owner" {
  value = "Owner of this instance: ${split(":",aws_instance.elb_instance.arn)[4]}"
  description = "Owner of aws_instance.elb_instance"
  sensitive = true

  depends_on = [ aws_instance.elb_instance ]
}

output "default_public_subnet_ids" {
  value = data.aws_subnets.default_public_subnets.ids
  description = "Fetch public subnets only."
}

output "route_table" {
  value = data.aws_vpc.regional_default.main_route_table_id
}
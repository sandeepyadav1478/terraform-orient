variable "primary_region" {
  type = string
  nullable = false
  default = "us-east-1"
}

variable "aws_profile" {
  type = string
  nullable = false
}

variable "instance_type" {
  type = string
  nullable = false
  default = "t2.micro"
  description = "Used in general checkup"
}
variable "primary_region" {
  description = "primary region for deployments"
  type = string
  default = "ap-south-1"
}

variable "default_instance_type" {
  description = "general instace for application launch"
  type = string
  default = "t2.micro"
}
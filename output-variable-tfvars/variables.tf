variable "primary_region" {
  type = string
  nullable = false
  # default = "us-east-1"
}

variable "aws_profile" {
  type = string
  nullable = false
  sensitive = true
  default = "devops-user"
  description = "local system, aws user profile of cli"
  validation {
    condition = length(var.aws_profile) > 2
    error_message = "Provide valid user of aws."
  }
}
terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "= 5.48.0"
    }
  }
  required_version = "~> 1.8.2"
}
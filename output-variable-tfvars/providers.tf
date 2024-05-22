provider "aws" {
  profile = var.aws_profile
  region = var.primary_region
}

provider "aws" {
  alias = "usa"
  profile = "devuser"
  region = "us-east-1"
}
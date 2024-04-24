provider "aws" {
  # Reference the variables defined in dev.tfvars
  profile = "terraform"
  region = var.primary_region
}
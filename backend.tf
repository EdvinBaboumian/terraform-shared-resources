terraform {
  backend "s3" {
    bucket         = "my-actual-company-terraform-state" # <-- Fix this line
    key            = "wordpress/prod/terraform.tfstate"
    region         = "us-east-1" # <-- Ensure correct region
    encrypt        = true
  }
}
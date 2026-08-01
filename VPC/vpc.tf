# main.tf

# 1. Define the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# 2. Deploy the VPC using the community module
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "production-vpc"
  cidr = "10.0.0.0/16"

  # High availability distribution
  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  # Enable internet access configurations
  enable_nat_gateway = true
  single_nat_gateway = false # Keeps costs down; set to false for production high availability

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Terraform   = "true"
    Environment = "prod"
  }
}
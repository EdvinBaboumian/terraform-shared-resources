# 1. Specify the Required Providers and Versions
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.2.0"
}

# 2. Configure the AWS Provider
provider "aws" {
  region = "us-east-1" # Change to your preferred AWS region
}

# 3. Fetch the Latest Ubuntu 22.04 LTS AMI Automatically
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical's official AWS Owner ID
}

# 4. Define the EC2 Instance Resource
resource "aws_instance" "web_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro" # Free-tier eligible instance type

  tags = {
    Name        = "Terraform-Ubuntu-Server"
    Environment = "Dev"
  }
}

# 5. Output the Public IP Address after Deployment
output "instance_public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = aws_instance.web_server.public_ip
}
variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region for deployment"
}

variable "environment" {
  type        = string
  default     = "prod"
  description = "Environment name"
}

variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "Base VPC CIDR block"
}

variable "instance_type" {
  type        = string
  default     = "t3.small"
  description = "EC2 Instance type for Auto Scaling Group"
}

variable "db_name" {
  type        = string
  default     = "wordpressdb"
  description = "Name of the MySQL database"
}

variable "db_user" {
  type        = string
  default     = "wpuser"
  description = "MySQL database admin username"
}

variable "db_password" {
  type        = string
  sensitive   = true
  description = "MySQL database admin password"
}
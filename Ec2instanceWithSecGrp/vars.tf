variable "region" {
  description = "The AWS region to create resources in."
  type        = string
  default     = "us-east-1"
  
}

variable "availability_zone" {
  description = "The AWS availability zone to create resources in."
  type        = string
  default     = "us-east-1a"
}

variable "ami_id" {
    type        = map(string)
    description = "Map of AMI IDs for different regions"
    default     = {
        "us-east-1" = "ami-0c02fb55956c7d316"
        "us-west-2" = "ami-0b898040803850657"
    }
}
# ALB Security Group (Public facing)
resource "aws_security_group" "alb_sg" {
  name        = "wordpress-alb-sg"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP from Internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "wordpress-alb-sg" }
}

# Private EC2 Instances Security Group
resource "aws_security_group" "ec2_sg" {
  name        = "wordpress-ec2-sg"
  description = "Allow traffic from ALB only"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "wordpress-ec2-sg" }
}

# RDS Security Group
resource "aws_security_group" "rds_sg" {
  name        = "wordpress-rds-sg"
  description = "Allow MySQL traffic from EC2 instances"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "MySQL from Private EC2"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "wordpress-rds-sg" }
}

# EFS Security Group
resource "aws_security_group" "efs_sg" {
  name        = "wordpress-efs-sg"
  description = "Allow NFS traffic from EC2 instances"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "NFS from EC2"
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]
  }

  tags = { Name = "wordpress-efs-sg" }
}
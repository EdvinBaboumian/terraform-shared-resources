resource "aws_db_subnet_group" "main" {
  name       = "wordpress-db-subnet-group"
  subnet_ids = [aws_subnet.private_1.id, aws_subnet.private_2.id]

  tags = { 
    Name = "wordpress-db-subnet-group" 
  }
}

resource "aws_db_instance" "wordpress" {
  identifier              = "wordpress-rds"
  allocated_storage       = 20
  max_allocated_storage   = 50
  engine                  = "mysql"
  engine_version          = "8.4" # Updated to LTS version (8.0 reaches EOL July 2026)
  instance_class          = "db.t3.micro"
  db_name                 = var.db_name
  username                = var.db_user
  password                = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.main.name
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  
  # Security & Disaster Recovery
  skip_final_snapshot     = false # Changed to false for production safety
  final_snapshot_identifier = "wordpress-rds-final-snapshot"
  publicly_accessible     = false
  storage_encrypted       = true
  
  # Backup Configuration (Fixed type from string "7" to integer 7)
  backup_retention_period = 7
  backup_window           = "03:00-04:00"

  tags = { 
    Name = "wordpress-rds" 
  }
}
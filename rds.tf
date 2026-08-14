resource "aws_db_subnet_group" "main" {
  name       = "wordpress-db-subnet-group"
  subnet_ids = [aws_subnet.private_1.id, aws_subnet.private_2.id]

  tags = { Name = "wordpress-db-subnet-group" }
}

resource "aws_db_instance" "wordpress" {
  identifier             = "wordpress-rds"
  allocated_storage      = 20
  max_allocated_storage  = 50
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  db_name                = var.db_name
  username               = var.db_user
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  skip_final_snapshot    = true
  publicly_accessible    = false

  tags = { Name = "wordpress-rds" }
}
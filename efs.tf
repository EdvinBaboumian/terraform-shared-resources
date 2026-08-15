resource "aws_efs_file_system" "wordpress_efs" {
  creation_token = "wordpress-efs"
  encrypted      = true

  tags = { Name = "wordpress-efs" }
}

resource "aws_efs_mount_target" "target_1" {
  file_system_id  = aws_efs_file_system.wordpress_efs.id
  subnet_id       = aws_subnet.private_1.id
  security_groups = [aws_security_group.efs_sg.id]
}

resource "aws_efs_mount_target" "target_2" {
  file_system_id  = aws_efs_file_system.wordpress_efs.id
  subnet_id       = aws_subnet.private_2.id
  security_groups = [aws_security_group.efs_sg.id]
}
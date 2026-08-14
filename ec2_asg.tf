data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

resource "aws_launch_template" "wordpress" {
  name_prefix   = "wordpress-lt-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  user_data = base64encode(<<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd php php-mysqlnd amazon-efs-utils

              # Start Web Server
              systemctl start httpd
              systemctl enable httpd

              # Mount EFS for shared uploads
              mkdir -p /var/www/html/wp-content/uploads
              mount -t efs -o tls ${aws_efs_file_system.wordpress_efs.id}:/ /var/www/html/wp-content/uploads
              echo "${aws_efs_file_system.wordpress_efs.id}:/ /var/www/html/wp-content/uploads efs _netdev,tls 0 0" >> /etc/fstab

              # Download and configure WordPress
              wget https://wordpress.org/latest.tar.gz -P /tmp
              tar -xzf /tmp/latest.tar.gz -C /var/www/html/ --strip-components=1

              # Configure wp-config.php
              cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
              sed -i "s/database_name_here/${var.db_name}/" /var/www/html/wp-config.php
              sed -i "s/username_here/${var.db_user}/" /var/www/html/wp-config.php
              sed -i "s/password_here/${var.db_password}/" /var/www/html/wp-config.php
              sed -i "s/localhost/${aws_db_instance.wordpress.endpoint}/" /var/www/html/wp-config.php

              # Fix permissions
              chown -R apache:apache /var/www/html
              chmod -R 755 /var/www/html
              EOF
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "wordpress" {
  name                = "wordpress-asg"
  vpc_zone_identifier = [aws_subnet.private_1.id, aws_subnet.private_2.id]
  target_group_arns   = [aws_lb_target_group.web.arn]

  min_size         = 2
  max_size         = 4
  desired_capacity = 2

  launch_template {
    id      = aws_launch_template.wordpress.id
    version = "$Latest"
  }

  health_check_type         = "ELB"
  health_check_grace_period = 300

  tag {
    key                 = "Name"
    value               = "wordpress-private-ec2"
    propagate_at_launch = true
  }
}
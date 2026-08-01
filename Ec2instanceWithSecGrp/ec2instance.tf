resource "aws_instance" "dave-ec2" {
  ami                    = data.aws_ami.amiID.id
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.dave-key.id
  vpc_security_group_ids = [aws_security_group.dave-sg.id]
  availability_zone      = "us-east-1a"

  tags = {
    Name = "dave-ec2"
  }
}
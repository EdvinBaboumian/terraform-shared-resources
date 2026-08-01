resource "aws_security_group" "dave-sg" {
  name        = "dave-sg"
  description = "dave-sg"
  #vpc_id      = aws_vpc.main.id

  tags = {
    Name = "dave-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ssh_rule" {
  security_group_id = aws_security_group.dave-sg.id
  cidr_ipv4         = "5.77.130.127/32"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_https_ipv4" {
  security_group_id = aws_security_group.dave-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "allow_all_outbound_ipv4" {
  security_group_id = aws_security_group.dave-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "allow_all_outbound_ipv6" {
  security_group_id = aws_security_group.dave-sg.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
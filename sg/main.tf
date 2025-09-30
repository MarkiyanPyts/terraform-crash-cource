provider "aws" {
  region = "eu-central-1"
}

resource "aws_instance" "ec2" {
    ami = "ami-0444794b421ec32e4"
    instance_type = "t2.micro"
    security_groups = [aws_security_group.webtraffic.name]
}

resource "aws_security_group" "webtraffic" {
    name = "Allow HTTPS"
}

resource "aws_vpc_security_group_ingress_rule" "allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.webtraffic.id
  cidr_ipv6         = "::/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.webtraffic.id
  cidr_ipv6         = "::/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}
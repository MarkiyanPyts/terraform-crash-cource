provider "aws" {
  region = "eu-central-1"
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "webtraffic" {
  name        = "allow-web"
  description = "Allow web + optional SSH"
  vpc_id      = data.aws_vpc.default.id

  dynamic "ingress" {
    for_each = toset(var.ingressrules_ports)
    content {
      from_port         = ingress.value
      to_port           = ingress.value
      protocol          = "tcp"
      cidr_blocks       = ["0.0.0.0/0"]
      ipv6_cidr_blocks  = ["::/0"]
      description       = "allow ingress port ${ingress.value} from anywhere"
    }
  }

  # optional SSH while testing
  ingress {
    from_port         = 22
    to_port           = 22
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
    ipv6_cidr_blocks  = ["::/0"]
    description       = "temporary SSH"
  }

  # wide-open egress (common default)
  egress {
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    cidr_blocks       = ["0.0.0.0/0"]
    ipv6_cidr_blocks  = ["::/0"]
    description       = "allow all egress"
  }
}

variable "ingressrules_ports" {
  type    = list(number)
  default = [80, 443]
}

resource "aws_instance" "db_ec2" {
  ami           = "ami-0444794b421ec32e4" # verify this for eu-central-1
  instance_type = "t2.micro"

  tags = {
    Name = "DB Server"
  }
}

output "PrivateIP" {
  value = aws_instance.db_ec2.private_ip
}

resource "aws_instance" "web_server" {
  ami                    = "ami-0444794b421ec32e4" # verify
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.webtraffic.id]

  # Make sure server-script.sh has a shebang and installs Apache
  user_data = file("server-script.sh")

  tags = {
    Name = "Web Server"
  }
}

# Allocate an Elastic IP in the VPC
resource "aws_eip" "web" {
  domain = "vpc"
}

# Associate it to the web instance
resource "aws_eip_association" "web" {
  allocation_id = aws_eip.web.allocation_id
  instance_id   = aws_instance.web_server.id
}

output "PublicIP" {
  value = aws_eip.web.public_ip
}

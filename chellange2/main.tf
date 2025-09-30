provider "aws" {
  region = "eu-central-1"
}

resource "aws_instance" "db_ec2" {
    ami = "ami-0444794b421ec32e4"
    instance_type = "t2.micro"
    
    tags = {
      Name = "DB Server"
    }
}

output "PrivateIP" {
    value = aws_instance.db_ec2.private_ip
}

resource "aws_instance" "web_server" {
    ami = "ami-0444794b421ec32e4"
    instance_type = "t2.micro"
    security_groups = [aws_security_group.webtraffic.name]

    tags = {
      Name = "Web Server"
    }

    user_data = file("server-script.sh")

}

variable "ingressrules_ports" {
    type = list(number)
    default = [443, 80]
}

variable "egressrules_ports" {
    type = list(number)
    default = [443, 80]
}

resource "aws_eip" "elasticeip" {
  instance = aws_instance.web_server.id
}

output "PublicIP" {
    value = aws_eip.elasticeip.public_ip
}

# Use dynamic blocks to generate ingress/egress rules from the variables.
resource "aws_security_group" "webtraffic" {
    name = "Allow HTTPS"

    dynamic "ingress" {
      for_each = var.ingressrules_ports
      content {
        from_port       = ingress.value
        to_port         = ingress.value
        protocol        = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
        description     = "allow ingress port ${ingress.value} from anywhere"
      }
    }

    dynamic "egress" {
      for_each = var.egressrules_ports
      content {
        from_port       = egress.value
        to_port         = egress.value
        protocol        = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
        description     = "allow egress port ${egress.value} to anywhere"
      }
    }
}
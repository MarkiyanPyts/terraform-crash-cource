provider "aws" {
  region = "eu-central-1"
}

resource "aws_instance" "ec2" {
    ami = "ami-0444794b421ec32e4"
    instance_type = "t2.micro"
    security_groups = [aws_security_group.webtraffic.name]
}

variable "ingressrules" {
    type = list(number)
    default = [443, 80]
}

variable "egressrules" {
    type = list(number)
    default = [80, 443, 25, 3306, 53, 8080]
}

# Use dynamic blocks to generate ingress/egress rules from the variables.
resource "aws_security_group" "webtraffic" {
    name = "Allow HTTPS"

    dynamic "ingress" {
      for_each = var.ingressrules
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
      for_each = var.egressrules
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
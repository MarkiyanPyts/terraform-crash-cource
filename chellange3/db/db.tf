variable "db_instance_name" {
  type    = string
}

resource "aws_instance" "db_ec2" {
  ami           = "ami-0444794b421ec32e4" # verify this for eu-central-1
  instance_type = "t2.micro"

  tags = {
    Name = var.db_instance_name
  }
}

output "PrivateIP" {
  value = aws_instance.db_ec2.private_ip
}
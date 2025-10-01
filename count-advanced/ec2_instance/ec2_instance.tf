variable "instance_names" {
  type    = list(string)
}

resource "aws_instance" "ec2_instance" {
  ami           = "ami-0444794b421ec32e4" # verify this for eu-central-1
  instance_type = "t2.micro"

  tags = {
    Name = var.instance_names[count.index]
  }

  count = length(var.instance_names)
}

output "PrivateIP" {
  value = [aws_instance.ec2_instance.*.private_ip]
}
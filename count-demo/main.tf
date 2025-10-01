provider "aws" {
  region = "eu-central-1"
}

resource "aws_instance" "ec2" {
    ami = "ami-0444794b421ec32e4"
    instance_type = "t2.micro"
    count = 3
}
provider "aws" {
  region = "eu-central-1"
}

resource "aws_instance" "db" {
    ami = "ami-0444794b421ec32e4"
    instance_type = "t2.micro"
}

resource "aws_instance" "web" {
    ami = "ami-0444794b421ec32e4"
    instance_type = "t2.micro"

    depends_on = [ aws_instance.db ]
}

data "aws_instance" "bd_search" {
  filter {
    name = "tag:Name"
    values = [ "DB Server" ]
  }
}

output "dbservers" {
  value = data.aws_instance.bd_search.availability_zone
}
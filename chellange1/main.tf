provider "aws" {
  region = "eu-central-1"
}

resource "aws_vpc" "TerraformVPC" {
  cidr_block = "192.168.0.0/24"
  tags = {
    Name = "MyTerraformVPC"
  }
}
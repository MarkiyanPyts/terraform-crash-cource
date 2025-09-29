provider "aws" {
  region = "eu-central-1"
  
}

variable "vpcname" {
    type = string
    default = "myvpc"
}

variable "sshport" {
    type = number
    default = 22
}

variable "enabled" {
    type = bool
    default = true
}

variable "mylist" {
    type = list(string)
    default = ["Value1", "Value2"]
}

variable "mymap" {
    type = map(string)
    default = {
        key1 = "Value1"
        key2 = "Value2"
    }
}

variable "inputname" {
  type = string
  description = "Set The Name tag of the VPC"
}

resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = var.inputname
  }
}

output "vpcid" {
    value = aws_vpc.myvpc.id
}

variable "mytuple" {
    type = tuple([string, number, string])
    default = ["cats", 1, "dog"]
}

variable "myobj" {
  type = object({
    name = string
    port = list(number)
  })
  default = {
    name = "TJ"
    port = [22, 80, 443]
  }
}
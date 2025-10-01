provider "aws" {
  region = "eu-central-1"
}

module "ec2_instance" {
  source          = "./ec2_instance"
  instance_names = ["DB Server", "Web Server"]
}

output "instance_private_ips" {
  value = module.ec2_instance.PrivateIP
}

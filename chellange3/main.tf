provider "aws" {
  region = "eu-central-1"
}

module "web_instance" {
  source = "./web"
  web_instance_name = "Web Server"
}

output "PublicIP" {
  value = module.web_instance.PublicIP
}

module "db_instance" {
  source = "./db"
  db_instance_name = "DB Server"
}

output "PrivateIP" {
  value = module.db_instance.PrivateIP
}
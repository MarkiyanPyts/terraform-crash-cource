provider "aws" {
    region = "eu-central-1"
}

variable "servernames" {
    type = list(string)
    default = ["dev", "test", "prod"]
  
}

module "ec2module" {
    source = "./ec2"
    ec2name = "Name From Module"
    for_each = toset(var.servernames)
}

output "module_output" {
    # module.ec2module is a map because the module uses for_each.
    # Return a map of instance IDs keyed by the module instance key (server name).
    value = { for name, m in module.ec2module : name => m.instance_id }
}
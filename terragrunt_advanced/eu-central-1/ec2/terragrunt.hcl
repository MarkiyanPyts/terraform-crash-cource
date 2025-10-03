include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "tfr:///terraform-aws-modules/ec2-instance/aws?version=6.1.1"
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    # Use a realistic mock subnet id so dependent modules can reference it during init/plan
    private_subnets = ["subnet-00000000000000000"]
  }

  # Allow using mock outputs during 'init' as well as 'plan' so commands like
  # `terragrunt run --all -- init -migrate-state` can run before the dependency
  # module has actually been applied.
  mock_outputs_allowed_terraform_commands = ["init", "plan"]
}

inputs = {
  name = "single-instance"

  instance_type = "t2.micro"
  monitoring    = true
  subnet_id     = dependency.vpc.outputs.private_subnets[0]

  tags = {
    IaC         = "true"
    Environment = "dev"
  }
}
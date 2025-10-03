locals {
  region_hcl = find_in_parent_folders("region.hcl")
  region     = read_terragrunt_config(local.region_hcl).locals.region
}

# Configure the remote backend
remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket = "markiyan-terraform-bucket-2025-1759333217415"

    key            = "${path_relative_to_include()}/tofu.tfstate"
    region         = "eu-central-1"
    encrypt        = true
    dynamodb_table = "my-lock-table"
  }
}

# Configure the AWS provider
generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "aws" {
  region = "${local.region}"
}
EOF
}
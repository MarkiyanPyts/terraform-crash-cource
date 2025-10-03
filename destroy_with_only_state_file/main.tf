    terraform {
      backend "local" {
        path = "terraform.tfstate" # Point to your state file
      }
    }

    provider "aws" {
      region = "eu-central-1" # Use the correct region
    }
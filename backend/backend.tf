terraform {
    backend "s3" {
        bucket = "markiyan-terraform-bucket-2025-1759333217414"  # Change to your unique bucket name
        key    = "terraform/tfstate.tfstate"              # Path within the bucket
        region = "eu-central-1"                                 # Change to your desired region
        # Get aws config env var values from your local AWS CLI config or set them here
        access_key = ""                       # Optional: if not using environment variables or IAM roles
        secret_key = ""                  # Optional: if not using environment variables or IAM roles
        encrypt = true                                      # Enable server-side encryption
        # dynamodb_table = "my-tfstate-lock-table"          # Optional: for state locking
    }
}
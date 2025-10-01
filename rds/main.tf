provider "aws" {
  region = "eu-central-1"
}

resource "aws_db_instance" "myRDS" {
    db_name = "myDB"
    identifier = "my-first-rds"
    instance_class = "db.t3.micro"
    engine = "postgres"
    engine_version = "17.4"
    username = "postgres"
    password = "postgres"
    port = 5432
    allocated_storage = 20
    skip_final_snapshot = true
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  required_version = ">=0.14.9"

}

provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "malconip-terraform-state"
    key            = "tfstate-s3-bucket"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock-dynamo"
  }
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "malconip-terraform-state"

  versioning {
    enabled = true
  }
}

resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name           = "terraform-state-lock-dynamo"
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20
  tags = {
    Name = "DynamoDB Terraform State Lock Table"
  }
  attribute {
    name = "LockID"
    type = "S"
  }
}

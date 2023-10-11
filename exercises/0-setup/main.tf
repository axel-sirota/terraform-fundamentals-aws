terraform {
  required_version = "~>1.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.20"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }
}

provider "aws" {
  region = us-east-2
}

resource "random_integer" "rand" {
  max = 10000
  min = 0
}

resource "aws_s3_bucket" "student_buckets" {
  bucket        = "devint-${random_integer.rand.result}"
  force_destroy = true
}

output "bucket" {
  value = aws_s3_bucket.student_buckets.id
}
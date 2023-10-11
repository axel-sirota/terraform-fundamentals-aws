terraform {
  required_version = "~>1.4"
  backend "s3" {
    bucket = "axel-di-bucket"
    key    = "state/remote-state"
    region = "us-east-1"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.20"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
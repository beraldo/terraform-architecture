terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.23.1"
    }
  }
}

provider "aws" {
  # Configuration options
  profile = "rberaldoaws-admin"
  region  = "us-east-1"
}

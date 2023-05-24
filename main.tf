terraform {
  required_providers {
    doormat = {
      source  = "doormat.hashicorp.services/hashicorp-security/doormat"
      version = "~> 0.0.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}


provider "doormat" {}

data "doormat_aws_credentials" "creds" {
  role_arn = "arn:aws:iam::596514691779:role/aws_jjohnson_test-developer"
}

provider "aws" {
  region     = "us-east-1"
  access_key = data.doormat_aws_credentials.creds.access_key
  secret_key = data.doormat_aws_credentials.creds.secret_key
  token      = data.doormat_aws_credentials.creds.token
}

data "aws_caller_identity" "current" {}

output "caller_identity_arn" {
  value = data.aws_caller_identity.current.arn
}

resource "aws_instance" "web" {
  instance_type = "t3.micro"

  tags = {
    Name = "HelloWorld"
  }
}

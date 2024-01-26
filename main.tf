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

variable "role_arn" {
  type = string
}

provider "doormat" {}

data "doormat_aws_credentials" "creds" {
  role_arn = var.role_arn
}

provider "aws" {
  region     = "us-east-2"
  access_key = data.doormat_aws_credentials.creds.access_key
  secret_key = data.doormat_aws_credentials.creds.secret_key
  token      = data.doormat_aws_credentials.creds.token

  default_tags {
    tags = {
      Owner = "jjohnson"
    }
  }
}

data "aws_caller_identity" "current" {}

output "caller_identity_arn" {
  value = data.aws_caller_identity.current.arn
}

data "aws_ami" "amazon-2" {
  most_recent = true

  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
  owners = ["amazon"]
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.amazon-2.id
  instance_type = "t3.micro"

  tags = {
    Name = "HelloWorld2"
  }
}

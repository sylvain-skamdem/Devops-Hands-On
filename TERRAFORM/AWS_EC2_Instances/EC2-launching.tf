terraform {
    required_version = "1.4.2"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.59.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "sk_instance" {
  ami = "ami-02f3f602d23f1659d"
  instance_type = "t2.micro"
  count = 2
  key_name = "EC2 Tutorial - Sylvain"
  tags = {
    Name = "EC2-Demo-Sk"
    ManagedBy = "Terraform"
  }
}
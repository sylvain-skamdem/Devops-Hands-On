# Configure the version
terraform {
  required_version = "1.4.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.0"
    }
  }
}

# Configure the provider
provider "aws" {
  region = "us-east-1"
}

# Main resources
resource "aws_instance" "sk_instance" {
  ami           = "ami-069aabeee6f53e7bf"
  instance_type = "t2.micro"
  count         = 1
  key_name      = "EC2 Tutorial - Sylvain"
  user_data     = <<-EOF
    #!/bin/bash
    # Install httpd on Linux 2
    yum update -y
    yum install httpd -y
    systemctl start httpd
  EOF

  tags = {
    Name      = "Apache Server"
    ManagedBy = "Terraform"
  }
}
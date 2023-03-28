Create an EC2 instance with Terraform
In this section, we'll write the code to create an EC2 instance. We'll review how to set up the main.tf file to create an EC2 instance and the variable files to ensure the instance is repeatable across any environment.

Prerequisites:

AWS account;
AWS Identify and Access Management (IAM) credentials and programmatic access. The IAM credentials that you need for EC2 can be found here;
setting up AWS credentials locally with aws configure in the AWS Command Line Interface (CLI). You can find further details here;
a VPC configured for EC2. You can find a CloudFormation template to do that here; and
a code or text editor.
For the purposes of this section, we will use Visual Studio Code as a code editor. However, any text editor will work.

Step 1. Create the main.tf file
Open your text/code editor and create a new directory. Make a file called main.tf. When setting up the main.tf file, you will create and use the Terraform AWS provider -- a plugin that enables Terraform to communicate with the AWS platform -- and the EC2 instance.

First, add the provider code to ensure you use the AWS provider.

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}
Next, set up your Terraform resource, which describes an infrastructure object, for the EC2 instance.  This will create the instance. Define the instance type and configure the network.

resource "aws_instance" "" {
  ami           = var.ami
  instance_type = var.instance_type

  network_interface {
    network_interface_id = var.network_interface_id
    device_index         = 0
  }

  credit_specification {
    cpu_credits = "unlimited"
  }
}
Step 2. Create the variables.tf file
Once the main.tf file is created, it's time to set up the necessary variables. These variables let you pass in values, and ensure the code is repeatable. With variables, you can use your code within any EC2 environment.

When setting up the variables.tf file, include the following three variables:

The network interface ID to attach to the EC2 instance from the VPC.
The Amazon Machine Image (AMI) of an instance. In the code snippet below, the AMI defaults to Ubuntu.
The size of the instance. In the code snippet below, the instance type defaults to a t2 Micro instance size.
Within the variables.tf file, create the following variables:

variable "network_interface_id" {
  type = string
  default = "network_id_from_aws"
}

variable "ami" {
    type = string
    default = "ami-005e54dee72cc1d00"
}

variable "instance_type" {
    type = string
    default = "t2.micro"
}
Step 3. Create the EC2 environment
To deploy the EC2 environment, ensure you're in the Terraform module/directory in which you write the Terraform code, and run the following commands:

terraform init. Initializes the environment and pulls down the AWS provider.
terraform plan. Creates an execution plan for the environment and confirm no bugs are found.
terraform apply --auto-approve. Creates and automatically approves the environment.
Step 4. Clean up the environment
To destroy all Terraform environments, ensure that you're in the Terraform module/directory that you used to create the EC2 instance and run terraform destroy.


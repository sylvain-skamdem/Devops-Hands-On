# Terraform Hands-on

This repository contains little hands-on projects demonstrating the usage of Terraform for infrastructure provisioning and management.

## Prerequisites

Before getting started, make sure you have the following prerequisites installed:

- [Terraform](https://www.terraform.io/downloads.html): Version X.X.X or higher.
- [AWS CLI](https://aws.amazon.com/cli/): For AWS-specific deployments.
- [Any other dependencies or tools required for your specific project.]

## Project Structure

The project is structured as follows:

├── main.tf

├── variables.tf

├── outputs.tf

├── terraform.tfvars

├── scripts

│ ├── script1.sh

│ ├── script2.sh

│ └── ...

└── README.md


- `main.tf`: This file contains the main Terraform configuration, defining the infrastructure resources and their properties.
- `variables.tf`: Here, you can define variables used in the Terraform configuration, allowing for customization and parameterization.
- `outputs.tf`: Defines the outputs that Terraform will display after applying the configuration.
- `terraform.tfvars`: This file contains the values for the variables defined in `variables.tf`.
- `scripts/`: A directory containing any custom scripts used in the project.

## Usage

To use this project, follow these steps:

1. Clone the repository to your local machine:
```git
git clone https://github.com/your-username/terraform-hands-on.git
```
2. Change into the project directory:
```bash
cd terraform-hands-on
```

3. Update the `terraform.tfvars` file with the desired variable values.

4. Initialize the Terraform project:
```hcl
terraform init
```

5. Preview the changes that will be applied:
```hcl
terraform plan
```

6. Apply the Terraform configuration to create or update the infrastructure:
```hcl
terraform apply
```

7. Confirm the changes by typing `yes` when prompted.

## Clean Up

To clean up and destroy the created infrastructure, run the following command:
```hcl
terraform destroy
```

**Note:** This will permanently delete the infrastructure resources. Proceed with caution.

## Contributing

Contributions to this project are welcome! If you encounter any issues or have suggestions for improvements, please open an issue or submit a pull request.


# Ansible Hands-on

This repository contains a hands-on project demonstrating the usage of Ansible for automation and configuration management. 

## Prerequisites

Before getting started, make sure you have the following prerequisites installed:

- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html): Version X.X.X or higher.
- [Any other dependencies or tools required for your specific project.]

## Project Structure

The project is structured as follows:

├── playbook.yml

├── inventory.ini

├── roles/

│ ├── role1/

│ │ ├── tasks/

│ │ │ └── main.yml

│ │ ├── templates/

│ │ └── ...

│ ├── role2/

│ └── ...

└── README.md


- `playbook.yml`: This file contains the main Ansible playbook, defining the tasks and configuration to be applied to the target hosts.
- `inventory.ini`: The inventory file defines the hosts and groups of hosts that Ansible will manage.
- `roles/`: A directory containing Ansible roles, each with its own set of tasks, templates, and other resources.

## Usage

To use this project, follow these steps:

1. Clone the repository to your local machine:
```
git clone https://github.com/your-username/ansible-hands-on.git
```

2. Change into the project directory:
```bash
cd ansible-hands-on
```
3. Modify the `playbook.yml`, `inventory.ini`, and any other necessary files according to your specific requirements.

4. Run the Ansible playbook:
```
ansible-playbook -i inventory.ini playbook.yml
```

This will apply the defined tasks and configurations to the target hosts specified in the inventory file.

## Clean Up

To undo the changes made by the Ansible playbook, you can run the playbook with a cleanup or rollback task, or manually revert the changes on the target hosts.

## Contributing

Contributions to this project are welcome! If you encounter any issues or have suggestions for improvements, please open an issue or submit a pull request.


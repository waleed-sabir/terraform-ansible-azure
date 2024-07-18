# Azure VM Deployment and Configuration with Terraform and Ansible

This project demonstrates how to automate the deployment of a virtual machine (VM) on Azure using Terraform and configure it with Nginx using Ansible.

## Prerequisites

Before you begin, ensure you have the following installed:

- Terraform
- Ansible
- Azure CLI (for authentication)

## Setup Instructions

1. Clone the Repository

```bash
git clone <repository-url>
cd <repository-name>
```

2. Configure Azure Authentication

Ensure you are logged in to Azure CLI with the necessary permissions.

```bash
az login
```

3. Configure Remote Backend in Azure

To store the Terraform state remotely in Azure Storage, follow these steps:

**Create Azure Storage Account and Container**

First, create a resource group, storage account, and container using Azure CLI/Azure portal.

4. Initialize Terraform with Remote Backend using Custom Values

To set the backend values, you can provide them dynamically using the -backend-config flag during terraform init.

Run the following command to initialize Terraform with the custom backend configuration:

```sh
terraform init \
  -backend-config="resource_group_name=<resource group name>" \
  -backend-config="storage_account_name=<storage account name>" \
  -backend-config="container_name=<container name>" \
  -backend-config="key=<blob key name>"
```

5. Define Variables

Create a `terraform.tfvars` file with your specific values for all the variables defined in the `variables.tf` file

6. Deploy the Infrastructure

Apply the Terraform configuration to deploy the VM on Azure.

```bash
terraform apply
```

Confirm by typing yes when prompted.

7. Run Ansible Playbook

Once Terraform completes, Ansible will automatically configure the VM with Nginx using the public IP address provisioned by Terraform.
Project Structure

- `main.tf`: Defines Azure resources (VM, network, etc.) using Terraform.
- `variables.tf`: Contains input variables for Terraform.
- `playbook.yaml`: Ansible playbook to install and configure Nginx on the VM.
- `README.md`: This file providing project documentation.

## Cleanup

To avoid incurring charges, destroy the resources created by Terraform when they are no longer needed.

```bash
terraform destroy
```

Confirm by typing yes when prompted.

## Troubleshooting

- Terraform Errors: Check Terraform's output and logs for any error messages during deployment.
- Ansible Errors: Review Ansible's output (ansible-playbook command) for errors related to playbook execution.

## Additional Notes

- Ensure your Azure subscription has the necessary quotas and permissions to create VMs and associated resources.
- Adjust security settings and resource configurations as needed in main.tf and playbook.yaml based on your requirements.

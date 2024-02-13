# azure-virtual-desktop

Terraform configuration for deploying Azure Virtual Desktop (AVD) infrastructure.

## Prerequisites

- Active Azure Subscription
- Terraform CLI
- Azure CLI for authentication

## Usage

1. Set up authentication with the Azure CLI (`az login`).
2. Populate variables in `terraform.tfvars` file (you might need to create it).
3. Initialize Terraform: `terraform init`
4. Plan the deployment: `terraform plan`
5. Apply the changes: `terraform apply`

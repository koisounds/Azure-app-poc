# Azure-app-poc
This is a proof of concept that uses OIDC to connect a terraform VPC module to Azure. No secrets are in the repo. 


## What's in this repo

- **`infra/`** – Terraform for Azure:
  - Uses an **existing** resource group (by name).
  - Creates a Linux App Service Plan and a Linux Web App (Node 18 LTS, `WEBSITE_RUN_FROM_PACKAGE`).
  - State is stored in Azure Storage (azurerm backend).
- **`.github/workflows/terraform.yml`** – CI/CD:
  - **Push to `main`** (under `infra/` or the workflow) → `terraform apply`.
  - **Pull requests** or **workflow_dispatch** → `terraform plan` only.
  - Azure login and Terraform backend use **OIDC** (federated credentials); no client secret required.

## Prerequisites

1. **Azure**
   - A resource group (Terraform does not create it).
   - A storage account + container for Terraform state.
   - An **App registration** with a **federated credential** for GitHub OIDC (e.g. subject `repo:<org>/<repo>:ref:refs/heads/main`).

2. **GitHub**
   - Repo secrets:
     - `AZURE_CLIENT_ID`, `AZURE_TENANT_ID`, `AZURE_SUBSCRIPTION_ID`
     - `TFSTATE_RG`, `TFSTATE_STORAGE`, `TFSTATE_CONTAINER`, `TFSTATE_KEY`
     - `APP_RG` (resource group name), `NAME_PREFIX` (prefix for plan and web app names)

## Running locally

From the repo root:

cd infra
terraform init -backend-config="resource_group_name=..." -backend-config="storage_account_name=..." -backend-config="container_name=..." -backend-config="key=terraform.tfstate" -backend-config="use_oidc=true" -backend-config="use_azuread_auth=true"
terraform plan -var="resource_group_name=..." -var="name_prefix=..."
# terraform apply when ready


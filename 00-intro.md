# Azure CLI Authentication Guide

## Learning Goals
- Check the installed version of Terraform.
- Understand how to authenticate with Azure using the Azure CLI.
- Verify successful login and access to Azure resources.

## Introduction
Authenticating with the Azure CLI is a foundational step in managing Azure resources programmatically. This guide includes preliminary checks and authentication processes necessary for accessing Azure services.

**Note:** 
Terraform only supports authenticating to Azure via the Azure CLI. Authenticating using Azure PowerShell isn't supported. Therefore, while you can use the Azure PowerShell module when doing your Terraform work, you first need to authenticate to Azure using the Azure CLI.

## Step-by-Step Instructions

1. **Check Terraform Version:**

Open an integrated terminal on your workstation and type the following command to check the installed version of Terraform:
   
   `terraform version` 
   
   This will display the current version of Terraform installed on your workstation. The output should resemble the example shown below.

```
$ terraform version
Terraform v1.8.2
```
    
2. **Authenticate with Azure CLI:**

   In the integrated terminal on your workstation and type the following command to log in to Azure with your credentials.

 `$ az login -u [username]`

   Replace [username] and [password] with the credentials provided. This command authenticates your session with Azure, allowing you to manage resources.

```
coder@workstation-3 ~/terraform-fundamentals (main)
$ az login -u workstation-3@eficodetraining.onmicrosoft.com -p <your provided password>
[
  {
    "cloudName": "AzureCloud",
    "homeTenantId": "ce98c903-f521-4028-89dc-13227927e323",
    "id": "769d8f7e-e398-4cbf-8014-0019e1fdee59",
    "isDefault": true,
    "managedByTenants": [],
    "name": "Eficode Training Subscription",
    "state": "Enabled",
    "tenantId": "ce98c903-f521-4028-89dc-13227927e323",
    "user": {
      "name": "workstation-3@eficodetraining.onmicrosoft.com",
      "type": "user"
    }
  }
]
```

3. **Verify Azure Account Details:**

After successfully logging in, verify your account details by running the following command

`az account show`

The output should resemble the example shown below.

```
$ az account show
{
  "environmentName": "AzureCloud",
  "homeTenantId": "ce98c903-f521-4028-89dc-13227927e323",
  "id": "769d8f7e-e398-4cbf-8014-0019e1fdee59",
  "isDefault": true,
  "managedByTenants": [],
  "name": "Eficode Training Subscription",
  "state": "Enabled",
  "tenantId": "ce98c903-f521-4028-89dc-13227927e323",
  "user": {
    "name": "workstation-3@eficodetraining.onmicrosoft.com",
    "type": "user"
  }
}

```

- [ ] CONSIDER ADDING A SECTION TO INTRODUCE THE AZURE PORTAL UI SO PEOPLE CAN OBSERVE THE CREATED RESOURCES DURING THE TRAINING

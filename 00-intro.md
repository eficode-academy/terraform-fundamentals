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

**paste output**

3. **Verify Azure Account Details:**

After successfully logging in, verify your account details by running the following command

`az account show`

The output should resemble the example shown below.
# Azure CLI Authentication Guide

## Learning Goals

- Check the installed version of Terraform.
- Understand how to authenticate Terraform with Azure using the Azure CLI.
- Verify successful login and access the Azure UI portal.

## Introduction

Authenticating with the Azure CLI is a foundational step in managing Azure resources programmatically. This guide includes preliminary checks and authentication processes necessary for accessing Azure services.

**Note:**
Terraform only supports authenticating to Azure via the Azure CLI. Authenticating using Azure PowerShell isn't supported. Therefore, while you can use the Azure PowerShell module when doing your Terraform work, you first need to authenticate to Azure using the Azure CLI.

## Step-by-Step Instructions

### 1 Check Terraform Version

Open the terminal on your workstation by right clicking in the File Explorer sidebar on the left side of the screen and select _Open in Integrated Terminal_ , and type the following command to check the installed version of Terraform:

   `terraform version`

   This will display the current version of Terraform installed on your workstation. The output should resemble the example shown below.

```shell
$ terraform version
Terraform v1.8.2
```

### 2 Authenticate with Azure CLI

   In the integrated terminal on your workstation and type the following command to log in to Azure with your credentials.

 `$ az login -u [username]`

   Replace [username] and [password] with the credentials provided. This command authenticates your session with Azure, allowing you to manage resources.

```shell
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

### 3 Verify Azure Account Details

After successfully logging in, verify your account details by running the following command

`az account show`

The output should resemble the example shown below.

```shell
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

### 4 Login to Azure Portal

Try typing

`az login`

A window will pop up to warn you that you are about to open an external website.

![image](https://github.com/eficode-academy/terraform-fundamentals/assets/71190161/bd7cf2ab-32cb-4215-b040-b64dc435a2f7)

Click _Open_

Sign in using the username and the password you used for Azure CLI earlier.

You'll see a window titled _Action Required_, click on _Ask later_ to skip it.

![image](https://github.com/eficode-academy/terraform-fundamentals/assets/71190161/93ef475b-8703-4732-b4a1-fea821ec0d59)

![image](https://github.com/eficode-academy/terraform-fundamentals/assets/71190161/31bd9779-f773-4629-89e7-4852a5595ef1)

Now you should be able to access _Resource Groups_ in the _Navigate_ submenu, where we will be creating most of our resources going forward, then you are able to see the created objects.

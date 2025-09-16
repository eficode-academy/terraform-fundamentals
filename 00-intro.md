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
Terraform 1.13.2
```

### 2 Authenticate with Azure CLI

In the integrated terminal on your workstation and type the following command to log in to Azure with your credentials.

```bash
az login --use-device-code
```

  You will see a message like this:
 
To sign in, use a web browser to open the page https://microsoft.com/devicelogin 
and enter the code ABCD-1234 to authenticate.


#### Step-by-step authentication flow:

1. Copy the code shown in your terminal.  

2. Open a browser on your workstation and go to [https://microsoft.com/devicelogin](https://microsoft.com/devicelogin).  

3. Paste the code when prompted and click **Next**.  

4. Enter your Azure account email and password.  

5. Set up the **Microsoft Authenticator app**.  

6. Approve the sign-in request in the Authenticator app.  

7. After successful authentication, return to your terminal.  

8. Azure CLI will confirm that you are signed in and display your active subscription(s).
   - If multiple subscriptions are available, you may be prompted to choose which one to set as default.  
   - Press **Enter** to accept the suggested default, or choose a different subscription if prompted. 



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

Open `portal.azure.com` in your browser

Sign in using the username and the password you used for Azure CLI earlier.

![image](https://github.com/eficode-academy/terraform-fundamentals/assets/71190161/31bd9779-f773-4629-89e7-4852a5595ef1)

Now you should be able to access _Resource Groups_ in the _Navigate_ submenu, where we will be creating most of our resources going forward, then you are able to see the created objects.

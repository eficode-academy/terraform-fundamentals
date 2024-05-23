# 02-Create and Manage Resources with Terraform

## Learning Goals
- Deploy an Azure storage account using Terraform to host a static website.
- Understand the process of configuring Terraform resource blocks, providers block, data sources, outputs, and variables.
- Learn to manage Azure resources effectively with Terraform.

## Introduction
This exercise will guide you through the process of using Terraform to deploy a static website to Azure. 
You will learn how to write, plan, and apply Terraform configurations to create an Azure storage account, enable the static website feature, and upload content.

**Note:** 
The `web` directory contains all static files for your website.

### Step-by-Step Instructions:

### 1. Prepare Your Terraform Configuration

Navigate to the directory `labs/02-Create-and-Manage-Resources-with-Terraform/start`.

Inside, you will find the following empty Terraform files:

- **main.tf** - Defines the required resources for hosting a static website on Azure.
- **providers.tf** - Specifies the required version of Terraform and the providers you plan to use.
- **outputs.tf** - Contains output blocks that display the results of the resources created.
- **variables.tf** - Lists the variables used in the configuration.

Let's begin by configuring the Terraform settings and provider configurations in the `providers.tf` file. 

In the `providers.tf` file paste the following configuration.

**What is a Terraform Block?**

The special `terraform` configuration block is used to configure some behaviors of Terraform itself, such as requiring a minimum Terraform version to apply your configuration. Terraform settings are gathered together into `terraform` blocks:

```hcl
terraform {
  # ...
}
```

Let us configure the `terraform` block with some options like the `required_version` setting.

The `required_version` setting accepts a version constraint string, which specifies which versions of Terraform can be used with your configuration.

```hcl
terraform {
  required_version = ">=1.0"
}
```

Let's continue adding another option inside the `terraform` block. 

The `required_providers` block lists each provider required by the configuration along with additional details:

- `source`: Indicates where Terraform can find the provider's source code. Typically, this is in the form of `namespace/provider`, and for official providers like Azure and Random, `hashicorp/` is the namespace.
- `version`: Specifies the version or range of versions of the provider. The version constraint `~> 3.0` means it will use version 3.0 and any subsequent patch versions, but not 4.0 or later.

We are going to configure the Azure and Random providers within the `terraform` block in the `required_providers` block. This setup is necessary because we'll be using Azure Cloud for our infrastructure and the Random provider to generate unique names for storage accounts on Azure.

```hcl
required_providers {
  azurerm = {
    source  = "hashicorp/azurerm"
    version = "~>3.0"
  }
  random = {
    source  = "hashicorp/random"
    version = "~>3.0"
  }
}
```

After adding the two options to the `terraform` block you should have something like shown below.

```hcl
terraform {
  required_version = ">=1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }
}
```

**What is a Provider Block?**

The `provider` block configures the specified provider, in this case, `azurerm`. A provider is a plugin that Terraform uses to create and manage your resources. You can define multiple provider blocks in a Terraform configuration to manage resources from different providers.

This provider is maintained by the Azure team at Microsoft and the Terraform team at HashiCorp.

Paste the configuration into the buttom of `providers.tf`:

```hcl
provider "azurerm" {
  features {}
  tenant_id       = "ce98c903-f521-4028-89dc-13227927e323"
  subscription_id = "769d8f7e-e398-4cbf-8014-0019e1fdee59"
}
```

**Note:**
The `features {}` block must be included, as it's required by the Azure provider, although it's empty in this case, because the Azure provider doesn't require any features to be explicitly enabled.

Your `providers.tf` should look something like below:

```hcl
terraform {
  required_version = ">=1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
  tenant_id       = "ce98c903-f521-4028-89dc-13227927e323"
  subscription_id = "769d8f7e-e398-4cbf-8014-0019e1fdee59"
}
```
----

### 2. Configure the main.tf File for Azure Resources

In the `main.tf` file, we will define the necessary resources to host a static website on Azure. This setup includes creating a uniquely named storage account and configuring it to serve static content.

**Starting with Data and Resource Blocks**

1. **Data Block - Azure Client Configuration**
   
   Retrieves the configuration of the client running Terraform. Useful for obtaining properties like the account's subscription and tenant IDs if required.

   ```hcl
   data "azurerm_client_config" "current" {}
   ```

  Learn more about configuring the  azurerm_client_config data source:
   [Azure Client Config Data Source Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config)

2. **Resource Block - Random String for Storage Account Name**
   
   Generates a unique name for the Azure storage account, adhering to Azure's naming requirements.

   ```hcl
   resource "random_string" "storage_account_name" {
     length  = 8
     lower   = true
     numeric = false
     special = false
     upper   = false
   }
   ```

   Learn more about configuring the  random_string resource:
   [Random String Resource Documentation](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string)

3. **Resource Block - Azure Storage Account**
   
   Defines the storage account where the static website will be hosted, specifying type, replication, and static website settings.

   ```hcl
   resource "azurerm_storage_account" "storage_account" {
    resource_group_name = data.azurerm_resource_group.studentrg.name
    location            = data.azurerm_resource_group.studentrg.location

     name = random_string.storage_account_name.result

     account_tier             = "Standard"
     account_replication_type = "LRS"
     account_kind             = "StorageV2"
     allow_nested_items_to_be_public = false

     static_website {
       index_document = "index.html"
     }
   }
   ```

   Learn more about configuring the  azurerm_storage_account resource:
   [Azure Storage Account Resource Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account)

4. **Resource Block - Azure Storage Blob**
   
   Uploads the `index.html` file and`image.jpg`into the Azure storage account, placing it in the `$web` container used for static website hosting.

```hcl
resource "azurerm_storage_blob" "index" {
  name                   = "index.html"
  storage_account_name   = azurerm_storage_account.storage_account.name
  storage_container_name = "$web"
  type                   = "Block"
  content_type           = "text/html"
  source                 = "${path.root}/web/index.html"
}

resource "azurerm_storage_blob" "image" {
  name                   = "image.jpg"
  storage_account_name   = azurerm_storage_account.storage_account.name
  storage_container_name = "$web"
  type                   = "Block"
  content_type           = "image/jpeg"
  source                 = "${path.root}/web/image.jpg" 
}

```

Learn more about configuring the azurerm_storage_blob resource:
   [Azure Storage Blob Resource Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_blob)

**Assembling the Configuration in `main.tf`**

After adding these blocks to your `main.tf` file, you'll have a complete configuration for deploying a static website. 
 
Your `main.tf` should look something like this:

```hcl
data "azurerm_client_config" "current" {}


# Generate random value for the storage account name
resource "random_string" "storage_account_name" {
  length  = 8
  lower   = true
  numeric = false
  special = false
  upper   = false
}

resource "azurerm_storage_account" "storage_account" {
  resource_group_name = data.azurerm_resource_group.studentrg.name
  location            = data.azurerm_resource_group.studentrg.location

  name = random_string.storage_account_name.result

  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  allow_nested_items_to_be_public  = false

  static_website {
    index_document = "index.html"
  }
}

resource "azurerm_storage_blob" "index" {
  name                   = "index.html"
  storage_account_name   = azurerm_storage_account.storage_account.name
  storage_container_name = "$web"
  type                   = "Block"
  content_type           = "text/html"
  source                 = "${path.root}/web/index.html"
}

resource "azurerm_storage_blob" "image" {
  name                   = "image.jpg"
  storage_account_name   = azurerm_storage_account.storage_account.name
  storage_container_name = "$web"
  type                   = "Block"
  content_type           = "image/jpeg"
  source                 = "${path.root}/web/image.jpg" 
}
```
----

### 3.Configure `outputs.tf` for Azure Resources

The `outputs.tf` file defines the output variables that will be displayed after Terraform applies its configurations. These outputs can be useful for obtaining direct links or important information regarding the deployed resources.

Insert the code below into `outputs.tf` and save the file.



```hcl
output "storage_account_name" {
  value = azurerm_storage_account.storage_account.name
  description = "The name of the storage account."
}

output "primary_web_host" {
  value = azurerm_storage_account.storage_account.primary_web_endpoint
  description = "The primary web endpoint for the static website."
}
```
For more attributes that you can output from the Azure Storage Account, visit the [Azure Storage Account Resource Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account).

These outputs will provide easy access to the storage account name and the URL of the static website hosted on Azure after deployment.

### 4.Configure `variables.tf` for Input Customization

The `variables.tf` file is used to define variables that will be used throughout your Terraform configurations, allowing for parameterization and reusability.

Insert the code below into `variables.tf` and save the file.

```hcl
variable "container_name" {
  type        = string
  description = "name of the container in the storage account."
  default     = "$web"
}
```

This variable allow you to specify the name of the soniter inside storage account, which can be overridden at runtime if needed.


### 5. Running Terraform Commands

Once your configuration files are set up, follow these steps to deploy your infrastructure:

#### Initialize Terraform

```bash
terraform init
```
This command initializes the project, installs the required provider plugins, and prepares your project for deployment.

#### Plan the Deployment

```bash
terraform plan
```
This command shows you what Terraform intends to do before making any changes to your actual resources. It's a good practice to review this output to avoid unexpected changes.

#### Apply the Configuration

```bash
terraform apply
```
This command applies the configurations. Terraform will prompt you to approve the action before proceeding. After approval, it will provision the resources specified in your Terraform files.

#### View the Deployed Website

Once the deployment is complete, Terraform will output the `primary_web_host`, which contains the URL to your static website:

The below is example of how the url will look like
```bash
Outputs:
primary_web_host = "https://example.z13.web.core.windows.net/"
```
**Open** a web browser and **navigate** to the URL displayed in the outputs to view your deployed static website.

### 6. Cleanup Resources

Execute the following command to remove all resources and clean up the infrastructure:

```bash
terraform destroy
```
This command will prompt you to review and confirm the destruction of the resources defined in your Terraform configuration. Once confirmed, Terraform will proceed to safely remove all the resources, effectively cleaning up the deployed infrastructure. This step helps prevent unnecessary costs and ensures that the environment is reset for future exercises.

# Congratulations 🎉

Following these instructions, you've successfully configured, deployed, and cleaned up a static website hosted on Azure using Terraform. This process not only automates your deployments, but also helps manage infrastructure as code efficiently.

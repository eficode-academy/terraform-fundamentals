# 03-Implementing Remote State Management

## Learning Goals

In this module, you will learn about the importance of remote state management in Terraform and how to configure a backend using the Azure provider.
This setup enhances your Terraform projects by enabling team collaboration and maintaining state consistency.

### Objectives

- Understand and implement remote state management.
- Configure an Azure backend for Terraform state.
- Verify the state file in Azure.
- View the deployed static website
- Clean up resources to prevent unnecessary charges.
- Manipulate Terraform state file.

## Step-by-Step Instructions

### 1. Introduction to Remote State

Remote state is a feature in Terraform that allows state information to be stored in a remote data store, which supports team collaboration and improves the security of state files.
Unlike local state files, remote state enables teams to share access to the state, ensuring everyone is working with the same configuration.

### 2. Configure the Azure Backend

The Azure backend stores state as a blob in a specified container on an Azure Storage Account.

This method is recommended for any sizable infrastructure or team-based projects.

#### Setting Up `backend.tf`

Navigate to the directory `labs/03-Implementing-Remote-State-Management`.

Inside, you will find both the `00start` and `01start` subdirectories.

**Prepare the Backend**:
Before configuring your remote backend, proceed to the `00start` subdirectory.

Here, execute the following Terraform commands to create a storage account that will house your state file:

1. Initialize the Terraform environment:

    `terraform init`

2. Generate and review the execution plan:

     `terrafom plan`

3. Apply the configuration (you will be prompted to approve the plan):

     `terraform apply`

During this, observe the local state file that is created in the current directory.

The command will output something of the like:

```plaintext
Apply complete! Resources: 3 added, 0 changed, 0 destroyed.

Outputs:

container_name = "tfstate"
storage_account_name = "qglcfvfh"
resource_group_name = "rg-resourcegrp"
```

❗ Take note of `container_name`, `storage_account_name` and `resource_group_name`. ❗

After successfully applying the Terraform configuration, pay close attention to the output.

The names of the storage account ,the container and resource group where the Terraform state will be stored are displayed. Ensure you copy these  accurately for later use.

After setting up the necessary outputs, exit the `00start` subdirectory and enter the `01start` subdirectory.

**Configure the Backend:**

The `01start` subdirectory contains all necessary configurations and files for hosting the static website on Azure, including an empty file named backend.tf

An empty file named `backend.tf` is present among them . This file will be used to configure your remote backend.

**Add Backend Configuration**:

**Task:**

Lets try to write the backend configuration on your own by referring to the Backend type azurerm documentation.

**Steps to Follow:**

1. Visit this link to know more about the azurerm backend.
[Backend type azurem](https://developer.hashicorp.com/terraform/language/settings/backends/azurerm)

2. Begin by defining the terraform block in your backend.tf file. This block is used to specify backend configuration.

   ```hcl
   terraform {
     backend "azurerm" {
       // Backend configuration parameters will go here
     }
   }
   ```

3. Required Parameters to define within the backend block:

   - resource_group_name: The name of the resource group containing the storage account.
   - storage_account_name: The name of the Azure Storage Account where the state file will be stored.
   - container_name: The container within the storage account where the state file will reside.
   - key: The name of the state file. Ensure this is unique to prevent overlap with other projects.
   - tenant_id and subscription_id: Your Azure account's tenant and subscription identifiers.

4. Paste the following configuration into `backend.tf`. This setup specifies the Azure backend for your Terraform state.

   ```hcl
   terraform {
     backend "azurerm" {
       resource_group_name   = "<resource-group-name>"
       storage_account_name  = "<name of the storage account>"
       container_name        = "<name of the container>"
       key                   = "unique-key-name.terraform.tfstate"
       tenant_id             = "ce98c903-f521-4028-89dc-13227927e323"
       subscription_id       = "769d8f7e-e398-4cbf-8014-0019e1fdee59"
     }
   }
   ```

❗**Important**:

- Replace `<resource group name>` with the name of the Azure Resource Group you have prepared for this configuration.
  
  This must be an existing resource group where you have permissions to create resources.

- Replace `<storage account name>` with the name of your Azure Storage Account.
  
  Ensure that the storage account name is unique within Azure and that it follows Azure naming conventions.

- Replace `<name of container>` with the name of the container in your Azure Blob Storage where you intend to store the Terraform state files.
  
  The container should be created beforehand if it does not already exist.

- Replace `<unique-key-name>` with a unique name to prevent conflicts and ensure your state file is distinctly identifiable.
  
  This can be the name of your workstation.

- Verify that `tenant_id` and `subscription_id` are correctly set to match your Azure tenant and subscription details where you want to manage resources.

**Explanation of Parameters**:

- `resource_group_name`: The name of the resource group containing the storage account.
- `storage_account_name`: The name of the Azure Storage Account where the state file will be stored.
- `container_name`: The container within the storage account where the state file will reside.
- `key`: The name of the state file. Ensure this is unique to prevent overlap with other projects.
- `tenant_id` and `subscription_id`: Your Azure account's tenant and subscription identifiers.

💡 Save the File 💡

### 3. Initializing Terraform with Remote Backend

Run the following command to initialize the Terraform configuration with your Azure backend:

```shell
terraform init
```

This command prepares your directory for Terraform operations with the specified backend. It ensures that Terraform is configured to manage your infrastructure remotely.

### 4. Verify and Apply Configuration

#### Verify the Deployment

```shell
terraform plan
```

This command shows you what Terraform intends to do before making any changes to your actual resources. It's a good practice to review this output to avoid unexpected changes.

#### Apply the Configuration

```shell
terraform apply
```

This command applies the configurations. Terraform will prompt you to approve the action before proceeding. After approval, it will provision the resources specified in your Terraform files.

### 5. View the Static Website

After deployment, Terraform outputs the URL of the static website:
  
```plaintext
primary_web_host = "https://example.z13.web.core.windows.net/"
```

Visit this URL in your web browser to view your deployed static website.

### 6. Verify the State File in Azure

- Log in to your Azure Portal.
- Navigate to the specified Storage Account by accessing Storage accounts(classic).

![image](https://github.com/eficode-academy/terraform-fundamentals/assets/71190161/ac55c146-cf98-4a81-9ed0-d92b5a9bb792)

- Look into the `tfstate` container to verify that the state file (`<unique-training-key>.terraform.tfstate`) is present.

### 7. Manipulating Terraform State

**List all resources in the current state file:**

```shell
terraform state list
```

**Display detailed information about a specific resource:**

```shell
terraform state show <resource_name>
```

Replace <resource_name> with one of the resources listed in the previous step.

**Refreshing and Forcing Re-creation of Resources:**

Update the state file to match the actual infrastructure:

```shell
terraform refresh
```

### 8. Cleanup Resources

To avoid incurring unnecessary charges:

- Run the following command in both the `00start` & `01start` sub directories :

```shell
terraform destroy
```

Confirm the action to remove all deployed resources.

### YAAAYYY 🎆

By completing this module, you have successfully learned how to manage Terraform state remotely using Azure as the backend enhancing your project's security and collaboration capabilities.

This setup not only ensures that your state file is secure and accessible but also facilitates teamwork by maintaining a single source of truth for your Terraform state.

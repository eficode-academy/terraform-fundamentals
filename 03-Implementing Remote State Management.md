# Implementing Remote State Management

## Learning Goals

In this module, you will learn about the importance of remote state management in Terraform and how to configure a backend using the Azure provider. This setup enhances your Terraform projects by enabling team collaboration and maintaining state consistency.

### Objectives

- Understand and implement remote state management.
- Configure an Azure backend for Terraform state.
- Verify the state file in Azure.
- View the deployed static website.
- Clean up resources to prevent unnecessary charges.

## Step-by-Step Instructions

### 1. Introduction to Remote State

Remote state is a feature in Terraform that allows state information to be stored in a remote data store, which supports team collaboration and improves the security of state files. Unlike local state files, remote state enables teams to share access to the state, ensuring everyone is working with the same configuration.

### 2. Configure the Azure Backend

The Azure backend stores state as a blob in a specified container on an Azure Storage Account. This method is recommended for any sizable infrastructure or team-based projects.

#### Setting Up `backend.tf`

Navigate to the directory `Create and Manage Resources with Terraform`.

Inside, you will find the `start` subdirectory. All necessary configurations and files for hosting the static website on azure are present. An empty file named `backend.tf` is present among them . This file will be used to configure your remote backend.


**Add Backend Configuration**:

   - Paste the following configuration into `backend.tf`. This setup specifies the Azure backend for your Terraform state.

   ```hcl
   terraform {
     backend "azurerm" {
       resource_group_name   = "rg-testexercise"
       storage_account_name  = "efitfstate"
       container_name        = "tfstate"
       key                   = "unique-key-name.terraform.tfstate"
       tenant_id             = "ce98c903-f521-4028-89dc-13227927e323"
       subscription_id       = "769d8f7e-e398-4cbf-8014-0019e1fdee59"
     }
   }
   ```

   **Important**: Replace `unique-key-name` with the name of your workstation to prevent conflicts and ensure your state file is distinctly identifiable.

**Explanation of Parameters**:
   - `resource_group_name`: The name of the resource group containing the storage account.
   - `storage_account_name`: The name of the Azure Storage Account where the state file will be stored.
   - `container_name`: The container within the storage account where the state file will reside.
   - `key`: The name of the state file. Ensure this is unique to prevent overlap with other projects.
   - `tenant_id` and `subscription_id`: Your Azure account's tenant and subscription identifiers.


Visit this link to know more about the azurerm backend:
[Backend type azurem](https://developer.hashicorp.com/terraform/language/settings/backends/azurerm)

 **Save the File**


### 3. Initializing Terraform with Remote Backend

- Run the following command to initialize the Terraform configuration with your Azure backend:

  ```bash
  terraform init
  ```

  This command prepares your directory for Terraform operations with the specified backend. It ensures that Terraform is configured to manage your infrastructure remotely.

### 4. Verify and Apply Configuration

#### Verify the Deployment

```bash
terraform plan
```
This command shows you what Terraform intends to do before making any changes to your actual resources. It's a good practice to review this output to avoid unexpected changes.

#### Apply the Configuration

```bash
terraform apply
```
This command applies the configurations. Terraform will prompt you to approve the action before proceeding. After approval, it will provision the resources specified in your Terraform files.

### 5. View the Static Website

- After deployment, Terraform outputs the URL of the static website:
  
  ```plaintext
  primary_web_host = "https://example.z13.web.core.windows.net/"
  ```

- **Visit** this URL in your web browser to view your deployed static website.

### 6. Verify the State File in Azure

- Log in to your Azure Portal.
- Navigate to the specified Storage Account (`efitfstate`).
- Look into the `tfstate` container to verify that the state file (`unique-training-key.terraform.tfstate`) is present.

### 7. Cleanup Resources

To avoid incurring unnecessary charges:

- Run the following command:

  ```bash
  terraform destroy
  ```

  Confirm the action to remove all deployed resources.

### YAAAAYYYYYYYY 🎆

By completing this module, you have successfully slearned how to manage Terraform state remotely using Azure as the backend enhancing your project's security and collaboration capabilities. This setup not only ensures that your state file is secure and accessible but also facilitates teamwork by maintaining a single source of truth for your Terraform state.

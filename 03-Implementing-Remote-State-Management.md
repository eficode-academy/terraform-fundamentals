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

## Step-by-Step Instructions

### 1. Introduction to Remote State

Remote state is a feature in Terraform that allows state information to be stored in a remote data store, which supports team collaboration and improves the security of state files. 
Unlike local state files, remote state enables teams to share access to the state, ensuring everyone is working with the same configuration.

### 2. Configure the Azure Backend

The Azure backend stores state as a blob in a specified container on an Azure Storage Account. This method is recommended for any sizable infrastructure or team-based projects.

#### Setting Up `backend.tf`

Navigate to the directory `03-Implementing-Remote-state-management`.

Inside, you will find both the `01start` and `00start` subdirectories.

**Prepare the Backend**:
Before configuring your remote backend, proceed to the `00start` subdirectory. Here, execute the following Terraform commands to create a storage account that will house your state file:

1. Initialize the Terraform environment:

   `terraform init`

During this initialization, observe the local state file that is created.

Note that storing sensitive information in local state files can be risky as these files can easily be exposed to unauthorized access if not properly secured.

2. Generate and review the execution plan:

  `terrafom plan`

3. Apply the configuration (you will be prompted to approve the plan):

  `terraform apply`

It will output something of the like:

```
Apply complete! Resources: 3 added, 0 changed, 0 destroyed.

Outputs:

container_name = "tfstate"
storage_account_name = "qglcfvfh"
```

* Take note of `container_name` and `storage_account_name`.

After successfully applying the Terraform configuration, pay close attention to the output. 
The names of the storage account and the container where the Terraform state will be stored are displayed. Ensure you copy these names accurately for later use.

Now exit the subdirectory `00start` and go the to subdirectory `01start`. 
All necessary configurations and files for hosting the static website on Azure are present. 
An empty file named `backend.tf` is present among them . This file will be used to configure your remote backend.

**Copy the Storage Account and Container Names**:

- **Storage Account Name**: This is the Azure Storage Account name displayed in the output. You will need this to configure the `storage_account_name` field in your `backend.tf`.
  
- **Container Name**: This is the name of the container within the Azure Storage Account displayed in the output. This will be used to configure the `container_name` field in your `backend.tf`.

These details are critical for setting up the remote backend correctly, so it's important to ensure they are noted precisely.

**Configure the Backend:**

After setting up the necessary resources, exit the 00start subdirectory and enter the 01start subdirectory. This location contains all necessary configurations and files for hosting the static website on Azure, including an empty file named backend.tf. This file will be used to set up your remote backend.

**Add Backend Configuration**:

   - Paste the following configuration into `backend.tf`. This setup specifies the Azure backend for your Terraform state.

   ```hcl
   terraform {
     backend "azurerm" {
       resource_group_name   = "<resource-group-name>"
       storage_account_name  = "<name of the storage account>"
       container_name        = "<name of teh conatiner>"
       key                   = "unique-key-name.terraform.tfstate"
       tenant_id             = "ce98c903-f521-4028-89dc-13227927e323"
       subscription_id       = "769d8f7e-e398-4cbf-8014-0019e1fdee59"
     }
   }
   ```

❗**Important**:
- Replace `<resource group name>` with the name of the Azure Resource Group you have prepared for this configuration. This must be an existing resource group where you have permissions to create resources.
- Replace `<storage account name>` with the name of your Azure Storage Account. Ensure that the storage account name is unique within Azure and that it follows Azure naming conventions.
- Replace `<name of container>` with the name of the container in your Azure Blob Storage where you intend to store the Terraform state files. The container should be created beforehand if it does not already exist.
- Replace `<unique-key-name>` with a unique name to prevent conflicts and ensure your state file is distinctly identifiable. This can be the name of your workstation.
- Verify that `tenant_id` and `subscription_id` are correctly set to match your Azure tenant and subscription details where you want to manage resources.


**Explanation of Parameters**:
   - `resource_group_name`: The name of the resource group containing the storage account.
   - `storage_account_name`: The name of the Azure Storage Account where the state file will be stored.
   - `container_name`: The container within the storage account where the state file will reside.
   - `key`: The name of the state file. Ensure this is unique to prevent overlap with other projects.
   - `tenant_id` and `subscription_id`: Your Azure account's tenant and subscription identifiers.


Visit this link to know more about the azurerm backend:
[Backend type azurem](https://developer.hashicorp.com/terraform/language/settings/backends/azurerm)

💡 Save the File 💡

- [ ] DESCRIBE HOW (maybe)

### 3. Initializing Terraform with Remote Backend

Run the following command to initialize the Terraform configuration with your Azure backend:

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

 - [ ] ADD SCREENSHOT

### 6. Verify the State File in Azure

- Log in to your Azure Portal.
- Navigate to the specified Storage Account .
- Look into the `tfstate` container to verify that the state file (`unique-training-key.terraform.tfstate`) is present.

### 7. Cleanup Resources

To avoid incurring unnecessary charges:

- Run the following command in both the `00start` & `01start` sub directiories :

  ```bash
  terraform destroy
  ```

  Confirm the action to remove all deployed resources.

### YAAAYYY 🎆

By completing this module, you have successfully learned how to manage Terraform state remotely using Azure as the backend enhancing your project's security and collaboration capabilities. 

This setup not only ensures that your state file is secure and accessible but also facilitates teamwork by maintaining a single source of truth for your Terraform state.

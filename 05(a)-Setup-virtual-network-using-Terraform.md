# 05(a)-Setup virtual network using Terraform

## Learning Goals

The 5th exercise is designed to be deployed in two parts - in the first part  you will set up the network configurations and in the second part you will deploy VMs using Terraform.

In this exercise, you will gain hands-on experience with Terraform to provision a virtual network in Azure.

![exercise5(1)](https://github.com/eficode-academy/terraform-fundamentals/assets/71190161/4d1be400-4d33-46ac-a41c-d216605fb670)

## Objective

* Create and configure a virtual network and subnets using Terraform.

## Step-by-Step Instructions

* Go to the folder `labs/05-Setup-VM-Using-Terraform/start`. That is where your exercise files should be created.

### Define Variables in `variables.tf`

We are going to define our variables seperately in a file.
This will help in managing configurations effectively and maintaining modularity.

Some of the variables we are going to set are:

* `exercise` for prefixing some of our objects so they are easy to manage together
* `admin_username` and `admin_password` for setting up a user on the new VM's which you will provision in the next part of the exercise.
* `source_image_reference` for the image that the VM's are going to use for provisioning in the next part of the exercise.

**Variable Declarations and Descriptions:**

1. **Go to the project directory**:
   * Navigate to `labs/05-Setup-VM-Using-Terraform/start` where your exercise files should be created.

2. **Create the `variables.tf` file**:
   * Create a new file named `variables.tf` in the `labs/05-Setup-VM-Using-Terraform/start` directory.

3. **Open the `variables.tf` file**:
   * Open the file you just created (`variables.tf`).

4. **Define the `exercise` variable**:
   * This variable should be of type `string`.
   * It will be used to make the names of some resources unique.
   * Provide a description that explains its purpose.

5. **Define the `network` variable**:
   * This variable should be an object containing a property `ranges` (a list of strings)
   * Set a default value with a typical network range, for example, `"10.0.0.0/16"`.
   * Provide a description that explains it is the virtual netwrok address range.

6. **Define the `client_subnet` variable**:
   * This variable should be an object with two properties: `name` (a string) and `ranges` (a list of strings).
   * Set default values for `name` and `ranges` (e.g., `"client"` and `"10.0.0.0/24"` respectively).
   * Provide a description that explains it is the subnet and address range for clients.

7. **Define the `server_subnet` variable**:
   * This variable should be an object with two properties: `name` (a string) and `ranges` (a list of strings).
   * Set default values for `name` and `ranges` (e.g., `"server"` and `"10.0.3.0/24"` respectively).
   * Provide a description that explains it is the subnet and address range for servers.

8. **Define the `admin_password` variable**:
   * This variable should be of type `string`.
   * Mark it as sensitive.
   * Provide a description that it is the default password to connect to the servers we deploy.

9. **Define the `admin_username` variable**:
   * This variable should be of type `string`.
   * Provide a description that it is the default admin user to connect to the servers we deploy.

10. **Define the `source_image_reference` variable**:

* This variable should be an object with four properties: `publisher`, `offer`, `sku`, and `version` (all strings).
* Set default values for each property:

  * publisher: Use "Canonical".
  * offer: Use "0001-com-ubuntu-server-jammy".
  * sku: Use "22_04-lts-gen2".
  * version: Use "latest".

* Provide a multi-line description explaining it is the SKU details for the image to be deployed.

   **Example for object with properties that are lists of strings:**
  
   To define a variable that is an object with properties that are lists of strings, you can use the object type with the appropriate property types.
   Consider this example:

 ```hcl

variable "network" {
  type = object({
    ranges = list(string)
  })
  default = {
    ranges = [
      "192.0.0.0/16"
    ]
  }

  description = "virtual address range"
}
```

In this example, network is an object with a property `ranges` that is a list of string.

11. **Save the `variables.tf` file**:
   * Ensure all your variable definitions are correctly formatted and saved.

Reference these variables in your future configurations using `var.<variable_name>` to dynamically configure resources based on defined values.

### 2. Set Values in `_config.auto.tfvars`

1. **Create the `config.auto.tfvars` file**:
   * In the same directory (`labs/05-Setup-VM-Using-Terraform/start`), create a new file named `_config.auto.tfvars`.

2. **Declare variable values in `_config.auto.tfvars`**:

   * Open `config.auto.tfvars` and add the following content to set values for the variables:

     ```hcl
     exercise = "exercise5"

     server_subnet = {
       name = "server"
       ranges = [
         "10.0.1.0/24"
       ]
     }

     admin_password = "aflk89!nknvlknglkvgew"
     admin_username = "adminuser"
     ```

3. **Save the `_config.auto.tfvars` file**:
   * Ensure the values are correctly formatted and saved.

### **Checkpoint 1**: Initialize Terraform

After defining your variables, initialize Terraform to ensure everything is set up correctly.

```bash
terraform init
terraform plan
```

This will ensure that your Terraform configuration is initialized and will allow you to verify that the variable setup is correct.

### 1. Introduction to Virtual Network Setup

A virtual network allows VMs and other resources to communicate with each other. Let's start with creating that.

### 2. Configure Network and Subnets

#### Creating `00_create_network.tf`

This configuration sets up the virtual network and associated subnets. This is crucial as it forms the foundational network infrastructure in which the VMs will operate.

**Task Instructions:**

1. **Go to the project directory**:
   * Navigate to `labs/05-Setup-VM-Using-Terraform/start` where your exercise files should be created.

2. **Create the `00_create_network.tf` file**:
  
   * Create a new file named `00_create_network.tf` in the `labs/05-Setup-VM-Using-Terraform/start` directory.

3. **Open the `00_create_network.tf` file**:
   * Open the file you just created (`00_create_network.tf`).

4. **Start the Terraform Block**:
   * Begin by adding an empty `terraform {}` block to indicate this file contains Terraform configuration.

     ```hcl
     terraform {}
     ```

5. **Define the Virtual Network Resource**:
   * Add the `azurerm_virtual_network` resource block.
   * Set the resource name to `exercise5`.
   * Set the `name` property to `"vnet-exercise5"`.
   * Set the `resource_group_name` property to `data.azurerm_resource_group.studentrg.name`.
   * Set the `location` property to `data.azurerm_resource_group.studentrg.location`.
   * Reference the `address_space` property to the variable you created earlier for network range like `var.network.ranges`.
  
6. **Define the Client Subnet Resource**:
   * Add the `azurerm_subnet` resource block for the client subnet.
   * Set the resource name to `client`.
   * Reference the `name` property to  the variable you created earlier for client subnet name like`var.client_subnet.name`.
   * Set the `resource_group_name` property to `data.azurerm_resource_group.studentrg.name`.
   * Set the `virtual_network_name` property to `azurerm_virtual_network.exercise5.name`.
   * Reference the  `address_prefixes` to  the variable you created earlier for client subnet ranges like `var.client_subnet.ranges`.
  
7. **Define the Server Subnet Resource**:
   * Add the `azurerm_subnet` resource block for the server subnet.
   * Set the resource name to `server`.
   * Refernece the `name` property to  the variable you created earlier for server subnet name like `var.server_subnet.name`.
   * Set the `resource_group_name` property to `data.azurerm_resource_group.studentrg.name`.
   * Set the `virtual_network_name` property to `azurerm_virtual_network.exercise5.name`.
   * Reference the `address_prefixes` property to  the variable you created earlier for server subnet range like `var.server_subnet.ranges`.

8. **Save the `00_create_network.tf` file**:
   * Ensure all configurations are correctly formatted.
   * Save the file in the `labs/05-Setup-VM-Using-Terraform/start` directory.

### Initialize Terraform, Plan and Apply Network Configuration

After defining the network and subnets, initialize Terraform again to make sure it's ready for the new resources and then validate your setup by running the following:

```bash
terraform init
terraform plan
```

If the plan looks correct, apply the configuration to create the network and subnets:

```bash
terraform apply
```

## Congratulations 🎉 🎉

By completing this exercise, you've learned to set up and manage network configurations in Azure using Terraform, which is crucial for effective cloud infrastructure management.

**Note:**
Do not destroy the resources yet.. you will need them for the next part of the exercise.

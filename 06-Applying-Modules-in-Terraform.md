# 06-Applying Modules in Terraform.md

## Learning Goals

This module provides an opportunity to use Terraform modules by creating a scalable and repeatable infrastructure with virtual machines (VMs) in Azure.

Modules are a good way to encapsulating configurations of related resources into reusable, shareable units. Both teams internal in a company, as well as providers can create them.

In this exercise, we are going to use the module [virtual-machine](https://registry.terraform.io/modules/Azure/virtual-machine/azurerm/latest) to simplifying creating a virtual machine in Azure.

This module defines 8 resources.

* azurerm_linux_virtual_machine.vm_linux
* azurerm_managed_disk.disk
* azurerm_network_interface.vm
* azurerm_storage_account.boot_diagnostics
* azurerm_virtual_machine_data_disk_attachment.attachment
* azurerm_virtual_machine_extension.extensions
* azurerm_windows_virtual_machine.vm_windows
* random_id.vm_sa


![exercise6(1)](https://github.com/eficode-academy/terraform-fundamentals/assets/71190161/1b3a6c71-9d40-4b62-acbd-03bf6e2a1c73)



## Objectives

* Understand the use of Terraform modules for resource deployment.
* Learn to interpret and apply configurations from YAML files.
* Deploy three virtual machines using the `for_each` construct to loop over configurations.
* Clean up resources to prevent unnecessary Azure charges.

## Step-by-Step Instructions

* Go to the folder `labs/06-Applying-Modules-in-Terraform/start`. That is where your exercise files should be created.

### Define Variables in `variables.tf`

Before diving into the actual Terraform configurations, we start by adding `variables.tf` file to our project like last exercise. 


**Task Instructions:**

1. **Create the `variables.tf` file**:
   - Navigate to `labs/06-Applying-Modules-in-Terraform/start`.
   - Create a new file named `variables.tf`.

2. **Define the following variables**:

   - `exercise`: A string variable used to make the name of some of the resources unique.

   - `instances_configuration`: A string variable pointing to a YAML file structured with VM configurations.
     ```hcl
     variable "instances_configuration" {
       type        = string
       description = <<EOT
             "Should point to a yaml file, structured as:"
             data:
                 VMNAME:
                     size: "VM SKU"
                     public_ip: true/false
                     subnet: client
                 client2:
                     size: "VM SKU"
                     public_ip: true
                     subnet: client
                 server:
                     size: "VM SKU"
                     public_ip: false
                     subnet: server
             EOT
     }
     ```
   - `network_configuration`: A string variable pointing to a YAML file structured with network configurations.
     ```hcl
     variable "network_configuration" {
       type        = string
       description = <<EOT
             "Should point to a yaml file, structured as:"
                 data:
                 ranges:
                 - 10.0.0.0/16
                 subnets:
                     client:
                         ranges:
                         - 10.0.0.0/24
                     server:
                         ranges:
                         - 10.0.1.0/24
             EOT
     }
     ```
   - `admin_password`: A sensitive string variable for the default password to connect to the servers.

     ```hcl
     variable "admin_password" {
       type        = string
       sensitive   = true
       description = "default password to connect to the servers we deploy"
     }
     ```

   - `admin_username`: A sensitive string variable for the default admin user to connect to the servers.

     ```hcl
     variable "admin_username" {
       type        = string
       sensitive   = true
       description = "default admin user to connect to the servers we deploy"
     }
     ```

If you encounter any issues or need to verify your configurations, refer to the `done` folder in the same directory for the solution.


### Define Configuration Values in `_config.auto.tfvars`

Create a `_config.auto.tfvars` file to automatically provide values for your variables during Terraform runs.

**Task Instructions:**

1. **Create the `_config.auto.tfvars` file**:
   - Navigate to `labs/06-Applying-Modules-in-Terraform/start`.
   - Create a new file named `_config.auto.tfvars`.

2. **Define the following values**:
   - `exercise`: Assign a unique identifier for your exercise.
   - `instances_configuration`: Provide the relative path to your `instances.yaml` file.
   - `network_configuration`: Provide the relative path to your `network.yaml` file.
   - `admin_username`: Assign a value for the admin username.
   - `admin_password`: Assign a value for the admin password.

   ```hcl
   exercise                = "exercise6"
   instances_configuration = "configuration/instances.yaml"
   network_configuration   = "configuration/network.yaml"
   admin_password          = "aflk89!nknvlknglkvgew"
   admin_username          = "adminuser"
   ```

If you encounter any issues or need to verify your configurations, refer to the `done` folder in the same directory for the solution.

### Create Network Resources

Create a file `00_create_network.tf` to set up the virtual network and associated subnets using data from `network.yaml`.

**Task Instructions:**

1. **Create the `00_create_network.tf` file**:
   - Navigate to the `labs/06-Applying-Modules-in-Terraform/start` directory.
   - Create a new file named `00_create_network.tf`.

2. **Define Local Variables to Read YAML Data**:
   - Inside the `00_create_network.tf` file, define a `locals` block.
   - Use the `file` function to read the content of the `network.yaml` file. Reference the file path using the `${path.root}/${var.network_configuration}` syntax.
   - Use the `yamldecode` function to convert the YAML file content into a data structure.
   - Store the decoded YAML data in a local variable named `yaml_network_data`.
   - Extract the `data` section from `yaml_network_data` and store it in another local variable named `network`.

3. **Create the Virtual Network**:
   - Define a `resource` block for the `azurerm_virtual_network` resource.
   - Name the resource block `main`.
   - Set the `name` property to `"vnet-${var.exercise}"` to include the exercise number for uniqueness.
   - Set the `resource_group_name` property to `data.azurerm_resource_group.studentrg.name`.
   - Set the `location` property to `data.azurerm_resource_group.studentrg.location`.
   - Set the `address_space` property to the value of `local.network.ranges`.

4. **Create Subnets**:
   - Define a `resource` block for the `azurerm_subnet` resource.
   - Name the resource block `main`.
   - Use the `for_each` expression to loop over the subnets defined in the `network` local variable.
   - Set the `name` property to the key of each subnet in the loop. Use `each.key` to reference the key.
   - Set the `resource_group_name` property to `data.azurerm_resource_group.studentrg.name`.
   - Set the `virtual_network_name` property to `azurerm_virtual_network.main.name`.
   - Set the `address_prefixes` property to the address ranges defined for each subnet. Use `each.value.ranges` to reference the ranges.

If you encounter any issues or need to verify your configurations, refer to the `done` folder in the same directory for the solution.

### Initialize and Plan Deployment

**Task Instructions:**

1. **Initialize Terraform**:
   - Run `terraform init` to prepare the backend and install required providers.

2. **Plan the Deployment**:
   - Run `terraform plan` to review the planned actions by Terraform.
   - Terraform will automatically use the values provided in `_config.auto.tfvars` file.

### Deploy Virtual Machines

Create a file `01_createinstances.tf` to deploy VMs based on configurations specified in `instances.yaml` using a Terraform module for VM creation.

**Task Instructions:**

1. **Create the `01_createinstances.tf` file**:
   - Navigate to the `labs/06-Applying-Modules-in-Terraform/start` directory.
   - Create a new file named `01_createinstances.tf`.

2. **Define Local Variables to Read YAML Data**:
   - Inside the `01_createinstances.tf` file, define a `locals` block.
   - Use the `file` function to read the content of the `instances.yaml` file.
   - Use the `yamldecode` function to convert the YAML file content into a data structure.
   - Store the decoded YAML data in a local variable named `yaml_vms_data`.
   - Extract the `data` section from `yaml_vms_data` and store it in another local variable named `instances`.

3. **Create Public IP Resources**:
   - Define a `resource` block for the `azurerm_public_ip` resource.
   - Name the resource block `pip`.
   - Use the `for_each` expression to create public IPs for VMs that require them, based on the YAML configuration.
   - Set the `name` property to `"${each.key}-public-ip"` to create a unique name for each public IP.
   - Set the `location` property to `data.azurerm_resource_group.studentrg.location`.
   - Set the `resource_group_name` property to `data.azurerm_resource_group.studentrg.name`.
   - Set the `allocation_method` property to `"Dynamic"`.
   - Add any necessary tags using the `tags` property.

4. **Use the Virtual Machine Module**:
   - Define a `module` block to utilize the `Azure/virtual-machine/azurerm` module.
   - Use the `for_each` expression to loop over VM configurations.
   - Set the `source` parameter to `"Azure/virtual-machine/azurerm"`.
   - Set the `version` parameter to `"1.1.0"`.
   - Configure the module with the following parameters:
     - `location`: Set to `data.azurerm_resource_group.studentrg.location`.
     - `resource_group_name`: Set to `data.azurerm_resource_group.studentrg.name`.
     - `image_os`: Set to `"linux"`.
     - `admin_username`: Set to `var.admin_username`.
     - `admin_password`: Set to `var.admin_password`.
     - `name`: Set to `each.key`.
     - `size`: Set to `each.value.size`.
     - `subnet_id`: Set to `azurerm_subnet.main[each.value.subnet].id`.
     - Add any necessary tags using the `tags` property.

5. **Define Network Interface Configuration**:
   - Set the `new_network_interface` parameter within the module block.
   - Configure the `new_network_interface` with the following properties:
     - `ip_forwarding_enabled`: Set to `false`.
     - `ip_configurations`: Define an array with the following properties:
       - `public_ip_address_id`: Reference the public IP created by the `azurerm_public_ip` resource block.
       - `primary`: Set to `true`.

6. **Define OS Disk Configuration**:
   - Set the `os_disk` parameter within the module block.
   - Configure the `os_disk` with the following properties:
     - `caching`: Set to `ReadWrite`.
     - `storage_account_type`: Set to `Standard_LRS`.

7. **Define Boot Diagnostics Configuration**:
   - Set the `new_boot_diagnostics_storage_account` parameter within the module block.
   - Configure the `new_boot_diagnostics_storage_account` to an empty object.

If you encounter any issues or need to verify your configurations, refer to the `done` folder in the same directory for the solution.

### Apply the Configuration

**Task Instructions:**

1. **Initialize Terraform**:
   - Run `terraform init` to prepare the backend and install required providers.

2. **Plan the Deployment**:
   - Run `terraform plan` to review the planned actions by Terraform.
   - Terraform will automatically use the values provided in `_config.auto.tfvars` file.


3. **Apply Terraform Configuration**:
   - Run `terraform apply`.
   - Terraform will automatically use the values provided in `_config.auto.tfvars` file.

4. **Verify the Deployment**:
   - Check the Azure portal to view the resources created in your resource group.


### Verify and Clean Up

After deploying the resources, verify the VMs' functionality by accessing them as needed. Ensure they are operating within the correct network and accessible per your configuration

To manage costs effectively and avoid unnecessary charges in Azure:

- Run `terraform destroy` to clean up all resources deployed during this exercise.

This command cleans up all resources deployed during this exercise.

## Well done

You've successfully utilized Terraform modules to deploy and manage virtual machines in Azure.

This exercise demonstrates the power of Terraform in managing complex infrastructure setups efficiently and repeatably.

# 05-Setup VM Using Terraform

## Learning Goals

In this module, you will gain hands-on experience with Terraform to provision a virtual network and deploy virtual machines (VMs) in Azure.

This exercise is designed to enhance your understanding of network configurations and VM deployment using Terraform, as well as giving you an idea around a larger set of Terraform files.

![exercise5(1)](https://github.com/eficode-academy/terraform-fundamentals/assets/71190161/4d1be400-4d33-46ac-a41c-d216605fb670)


## Objectives

* Create and configure a virtual network and subnets using Terraform.
* Deploy multiple client VMs with dynamic public IPs.
* Set up a server VM with a static public IP.
* Verify connectivity among deployed resources.
* Learn to clean up resources to avoid unnecessary charges.

## Step-by-Step Instructions

* Go to the folder `labs/05-Setup-VM-Using-Terraform/start`. That is where your exercise files should be created.

### Define Variables in `variables.tf`

We are going to define our variables seperately in a file.
This will help in managing configurations effectively and maintaining modularity.

Some of the variables we are going to set are:

* `exercise` for prefixing some of our objects to they are easy to manage together
* `admin_username` and `admin_password` for setting up a user on the new VM's
* `source_image_reference` for the image the VM's a going to use for provisioning.

**Variable Declarations and Descriptions:**

1. **Create a file named `variables.tf`**:
   - This file will hold all your variable definitions.

2. **Define the `exercise` variable**:
   - This variable should be of type `string`.
   - It will be used to make the names of some resources unique.
   - Provide a description that explains its purpose.

3. **Define the `network` variable**:
   - This variable should be an object with a property named `ranges` which is a list of strings.
   - Set a default value with a typical network range, for example, `"10.0.0.0/16"`.
   - Provide a description that explains it is the subnet and address range for clients.

4. **Define the `client_subnet` variable**:
   - This variable should be an object with two properties: `name` (a string) and `ranges` (a list of strings).
   - Set default values for `name` and `ranges` (e.g., `"client"` and `"10.0.0.0/24"` respectively).
   - Provide a description that explains it is the subnet and address range for clients.

5. **Define the `server_subnet` variable**:
   - This variable should be an object with two properties: `name` (a string) and `ranges` (a list of strings).
   - Set default values for `name` and `ranges` (e.g., `"server"` and `"10.0.3.0/24"` respectively).
   - Provide a description that explains it is the subnet and address range for servers.

6. **Define the `admin_password` variable**:
   - This variable should be of type `string`.
   - Mark it as sensitive.
   - Provide a description that it is the default password to connect to the servers we deploy.

7. **Define the `admin_username` variable**:
   - This variable should be of type `string`.
   - Provide a description that it is the default admin user to connect to the servers we deploy.

8. **Define the `source_image_reference` variable**:
   - This variable should be an object with four properties: `publisher`, `offer`, `sku`, and `version` (all strings).
   - Set default values for each property. For example, use `"Canonical"` for `publisher`, a relevant `offer`, `sku`, and `"latest"` for `version`.
   - Provide a multi-line description explaining it is the SKU details for the image to be deployed.
  
   To define a variable that is an object with properties that are lists of strings, you can use the object type with the appropriate property types.
   Consider this example:

 ```hcl
   variable "network" {
     type = object({
       subnets = list(object({
         name   = string
         ranges = list(string)
       }))
     })
     default = {
       subnets = [
         {
           name = "client"
           ranges = ["10.0.0.0/24"]
         },
         {
           name = "server"
           ranges = ["10.0.1.0/24"]
         }
       ]
     }
     description = "Network configuration with subnets and their respective address ranges"
   }
 ```
In this example, network is an object with a subnets property that is a list of objects. Each subnet object contains a name (a string) and ranges (a list of strings).

9. **Save the `variables.tf` file**:
   - Ensure all your variable definitions are correctly formatted and saved.


Reference these variables in your future configurations using `var.<variable_name>` to dynamically configure resources based on defined values.

### 2. Set Values in `_config.auto.tfvars`

1. **Create the `config.auto.tfvars` file**:
   - In the same directory (`labs/05-Setup-VM-Using-Terraform/start`), create a new file named `_config.auto.tfvars`.

2. **Declare variable values in `_config.auto.tfvars`**:

   - Open `config.auto.tfvars` and add the following content to set values for the variables:

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
   - Ensure the values are correctly formatted and saved.


### 1. Introduction to Virtual Network Setup

A virtual network allows VMs and other resources to communicate with each other. Let's start with creating that.

### 2. Configure Network and Subnets

#### Creating `00_create_network.tf`

This configuration sets up the virtual network and associated subnets. This is crucial as it forms the foundational network infrastructure in which the VMs will operate.

**Task Instructions:**

1. **Go to the project directory**:
   - Navigate to `labs/05-Setup-VM-Using-Terraform/start` where your exercise files should be created.

2. **Create the `00_create_network.tf` file**:
  
   - Create a new file named `00_create_network.tf` in the `labs/05-Setup-VM-Using-Terraform/start` directory.

3. **Open the `00_create_network.tf` file**:
   - Open the file you just created (`00_create_network.tf`).

4. **Start the Terraform Block**:
   - Begin by adding an empty `terraform {}` block to indicate this file contains Terraform configuration.

     ```hcl
     terraform {}
     ```

5. **Define the Virtual Network Resource**:
   - Add the `azurerm_virtual_network` resource block.
   - Set the resource name to `exercise5`.
   - Set the `name` property to `"vnet-exercise5"`.
   - Set the `resource_group_name` property to `data.azurerm_resource_group.studentrg.name`.
   - Set the `location` property to `data.azurerm_resource_group.studentrg.location`.
   - Reference the `address_space` property to the variable you created earlier for network range like `var.network.ranges`.
  
     ```hcl
     resource "azurerm_virtual_network" "exercise5" {
        name                = "vnet-${var.exercise}"
        resource_group_name = data.azurerm_resource_group.studentrg.name
        location            = data.azurerm_resource_group.studentrg.location
        address_space       = var.network.ranges
      }
     ```

6. **Define the Client Subnet Resource**:
   - Add the `azurerm_subnet` resource block for the client subnet.
   - Set the resource name to `client`.
   - Reference the `name` property to  the variable you created earlier for client subnet name like`var.client_subnet.name`.
   - Set the `resource_group_name` property to `data.azurerm_resource_group.studentrg.name`.
   - Set the `virtual_network_name` property to `azurerm_virtual_network.exercise5.name`.
   - Reference the  `address_prefixes` to  the variable you created earlier for client subnet ranges like `var.client_subnet.ranges`.
  
   ```hcl
     resource "azurerm_subnet" "client" {
        name                 = var.client_subnet.name
        resource_group_name  = data.azurerm_resource_group.studentrg.name
        virtual_network_name = azurerm_virtual_network.exercise5.name
        address_prefixes     = var.client_subnet.ranges
      }
   ```

7. **Define the Server Subnet Resource**:
   - Add the `azurerm_subnet` resource block for the server subnet.
   - Set the resource name to `server`.
   - Refernece the `name` property to  the variable you created earlier for server subnet name like `var.server_subnet.name`.
   - Set the `resource_group_name` property to `data.azurerm_resource_group.studentrg.name`.
   - Set the `virtual_network_name` property to `azurerm_virtual_network.exercise5.name`.
   - Reference the `address_prefixes` property to  the variable you created earlier for server subnet range like `var.server_subnet.ranges`.

   ```hcl
     resource "azurerm_subnet" "server" {
        name                 = var.server_subnet.name
        resource_group_name  = data.azurerm_resource_group.studentrg.name
        virtual_network_name = azurerm_virtual_network.exercise5.name
        address_prefixes     = var.server_subnet.ranges
      }
   ```

8. **Save the `00_create_network.tf` file**:
   - Ensure all configurations are correctly formatted.
   - Save the file in the `labs/05-Setup-VM-Using-Terraform/start` directory.

### 3\. Deploy Client VMs

Now with the network created, we can focus on creating the configuration for the client.

#### Creating `01_deployclients.tf`

This file handles the deployment of client VMs. Dynamic public IPs are assigned to these VMs, allowing external access and connectivity tests.

1. **Go to the project directory**:
   - Navigate to `labs/05-Setup-VM-Using-Terraform/start` where your exercise files should be created.

2. **Create the `01_deployclients.tf` file**:
  
   - Create a new file named `01_deployclients.tf` in the `labs/05-Setup-VM-Using-Terraform/start` directory.

### 3. Configuration Steps for `01_deployclients.tf`

1. **Define Local Variables**:

Begin by defining a local variable `clients` that contains a set of client names.
The `locals` block is used to define these local values that are constant within the module and can be referenced elsewhere in the configuration. 
This helps in managing reusable values. The `clients` variable specifies the list of clients that need to be created.

     ```hcl
     locals {
       clients = toset(["client1", "client2"]) 
     }
     ```

2. **Create Public IP Resources**:

Refer to the [AzureRM Public IP documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip).

   - Define the `azurerm_public_ip` resource block.
   - Use `for_each` to loop over the `clients` local variable.
   - Set the `name` property to include the client name.
   - Set the `location` and `resource_group_name` properties to use values from the Azure Resource Group data source.
   - Set the `allocation_method` to `"Dynamic"`.
   - Add tags with an `environment` set to `"Production"`.

   ```hcl
  resource "azurerm_public_ip" "client" { #Creates a dynamic public IP for each client VM
  for_each            = local.clients # Using the for_each construct to loop over the clients.
  name                = "${each.key}-public-ip"
  location            = data.azurerm_resource_group.studentrg.location
  resource_group_name = data.azurerm_resource_group.studentrg.name
  allocation_method   = "Dynamic"
   tags = {
    environment = "Production"
  }
  ```

3. **Create Network Interface Resources**:

Refer to the [AzureRM Network Interface documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface).

   - Add the `azurerm_network_interface` resource block for the client network interface.
   - Set the resource name to `client`.
   - Use the `for_each` expression to loop through the list of clients defined in the local block by referencing the local values:

     ```hcl
     for_each = local.clients
     ```

   - Set the `name` property to `"nic-${each.key}"`.
   - Set the `resource_group_name` property to `data.azurerm_resource_group.studentrg.name`.
   - Set the `location` property to `data.azurerm_resource_group.studentrg.location`.
   - Set the `ip_configuration` property. It is a nested block with its own set of arguments:
     - `name`: set the value to `"internal"`
     - `subnet_id`: reference the ID of the subnet created earlier, like `azurerm_subnet.client.id`
     - `private_ip_address_allocation`: set the value to `Dynamic`
     - `public_ip_address_id`: reference the public IP created by the resource above by referencing the resource value `azurerm_public_ip.client[each.key].id`
   - Set the dependency between subnet and network interface resource explicitly by using the `depends_on` expression.

```hcl
  resource "azurerm_network_interface" "client" {
  for_each            = local.clients
  name                = "nic-${each.key}"
  location            = data.azurerm_resource_group.studentrg.location
  resource_group_name = data.azurerm_resource_group.studentrg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.client.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.client[each.key].id
  }
  depends_on = [azurerm_subnet.client]
}
  ```

4. **Create Virtual Machine Resources**:

Refer to the [AzureRM Linux Virtual Machine documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine).

   - Add the `azurerm_linux_virtual_machine` resource block for creating the client virtual machines.
   - Use the `for_each` expression to loop through the list of clients defined in the local block by referencing the local values:

     ```hcl
     for_each = local.clients
     ```

   - Set the `name` property to include the client name: `"vm-${each.key}"`.
   - Set the `location` property to `data.azurerm_resource_group.studentrg.location`.
   - Set the `resource_group_name` property to `data.azurerm_resource_group.studentrg.name`.
   - Set the `size` property to `"Standard_B1ls"`.
   - Set the `admin_username` property to `var.admin_username`.
   - Set the `disable_password_authentication` property to `false`.
   - Set the `admin_password` property to `var.admin_password`.
   - Set the `network_interface_ids` property to `[azurerm_network_interface.client[each.key].id]`.

   ```hcl
     resource "azurerm_linux_virtual_machine" "client" {
        for_each                        = local.clients
        name                            = "vm-${each.key}"
        location                        = data.azurerm_resource_group.studentrg.location
        resource_group_name             = data.azurerm_resource_group.studentrg.name
        size                            = "Standard_B1ls"
        admin_username                  = var.admin_username
        disable_password_authentication = false
        admin_password                  = var.admin_password
        network_interface_ids           = [azurerm_network_interface.client[each.key].id]
   ```

   - Configure the `identity` block:
     - **`type`**: Set to `"SystemAssigned"`.

     ```hcl
     identity { 
       type = "SystemAssigned" 
     }
     ```

   - Configure the `boot_diagnostics` block:
     - **`storage_account_uri`**: Set to an empty string.

     ```hcl
     boot_diagnostics { 
       storage_account_uri = "" 
     }
     ```

   - Configure the `source_image_reference` block:
     - **`publisher`**: Set to `var.source_image_reference.publisher`.
     - **`offer`**: Set to `var.source_image_reference.offer`.
     - **`sku`**: Set to `var.source_image_reference.sku`.
     - **`version`**: Set to `var.source_image_reference.version`.

     ```hcl
     source_image_reference {
       publisher = var.source_image_reference.publisher
       offer     = var.source_image_reference.offer
       sku       = var.source_image_reference.sku
       version   = var.source_image_reference.version
     }
     ```

   - Configure the `os_disk` block:
     - **`storage_account_type`**: Set to `"Standard_LRS"`.
     - **`caching`**: Set to `"ReadWrite"`.

     ```hcl
     os_disk {
       storage_account_type = "Standard_LRS"
       caching              = "ReadWrite"
     }
     ```

5. **Save the `01_deployclients.tf` file**:
   - Ensure the configuration is correctly formatted and saved.


### 4. Deploy Server VM

#### Creating `01_deployserver.tf`

This configuration sets up a server VM with a static public IP, ensuring that it has a fixed entry point for network communications, which is essential for server roles.

**Task Instructions:**

1. **Go to the project directory**:
   - Navigate to `labs/05-Setup-VM-Using-Terraform/start` where your exercise files should be created.

2. **Create the `01_deployserver.tf` file**:
   - Create a new file named `01_deployserver.tf` in the `labs/05-Setup-VM-Using-Terraform/start` directory.

### 3. Configuration Steps for `01_deployserver.tf`

1. **Define a Static Public IP for the Server**:
   - Create a `resource` block for `azurerm_public_ip` named `server`.
   - Set the `name` property to `"server-public-ip"` to clearly identify this IP as belonging to the server.
   - Set the `location` and `resource_group_name` properties to the same values used for other resources, ensuring consistency.
   - Use the `allocation_method` property set to `"Static"` to ensure the IP address remains consistent across restarts and redeployments.
   - Optionally, add tags such as `environment` with the value `"Production"` for organizational purposes.
  
     ```hcl
     resource "azurerm_public_ip" "server" {
        name                = "server-public-ip"
        location            = data.azurerm_resource_group.studentrg.location
        resource_group_name = data.azurerm_resource_group.studentrg.name
        allocation_method   = "Static"

        tags = {
        environment = "Production"
        }
      }
     ```

2. **Create the Network Interface for the Server**:
   - Create a `resource` block for `azurerm_network_interface` named `server`.
   - Set the `name` property to `"nic-server"` to clearly identify this NIC as belonging to the server.
   - Set the `location` and `resource_group_name` properties to the same values used for other resources.
   - Within the `ip_configuration` nested block:
     - Set the `name` property to `"internal"` for the internal configuration.
     - Reference the `subnet_id` from the previously created server subnet (`azurerm_subnet.server.id`).
     - Set `private_ip_address_allocation` to `"Dynamic"`.
     - Reference the `public_ip_address_id` from the static public IP created earlier (`azurerm_public_ip.server.id`).
   - Add a `depends_on` property to ensure the subnet resource is created before the network interface. Use `[azurerm_subnet.server]` as the dependency.
  
     ```hcl
     resource "azurerm_network_interface" "server" {
        name                = "nic-server"
        location            = data.azurerm_resource_group.studentrg.location
        resource_group_name = data.azurerm_resource_group.studentrg.name

        ip_configuration {
           name                          = "internal"
           subnet_id                     = azurerm_subnet.server.id
           private_ip_address_allocation = "Dynamic"
           public_ip_address_id          = azurerm_public_ip.server.id
        }
        depends_on = [azurerm_subnet.server]
      }
     ```

3. **Create the Server VM**:
   - Create a `resource` block for `azurerm_linux_virtual_machine` named `server`.
   - Set the `name` property to `"vm-server"` to clearly identify this VM as the server.
   - Set the `location` and `resource_group_name` properties to the same values used for other resources.
   - Set the `size` property to `"Standard_B1ls"` or any appropriate VM size.
   - Use `var.admin_username` for the `admin_username` property to dynamically set the admin username.
   - Set `disable_password_authentication` to `false` to enable password authentication.
   - Use `var.admin_password` for the `admin_password` property to dynamically set the admin password.
   - Set the `network_interface_ids` property to the ID of the network interface created earlier (`azurerm_network_interface.server.id`).

4. **Configure VM Identity**:
   - Add an `identity` nested block within the VM resource.
   - Set the `type` property to `"SystemAssigned"` to assign a system-managed identity to the VM.

5. **Configure Boot Diagnostics**:
   - Add a `boot_diagnostics` nested block within the VM resource.
   - Set the `storage_account_uri` property to an empty string, or specify a storage account URI if required for boot diagnostics.

6. **Specify the Source Image**:
   - Add a `source_image_reference` nested block within the VM resource.
   - Set the `publisher`, `offer`, `sku`, and `version` properties to reference the source image for the VM, using variables defined in `variables.tf` (e.g., `var.source_image_reference.publisher`, `var.source_image_reference.offer`, etc.).

7. **Configure the OS Disk**:
   - Add an `os_disk` nested block within the VM resource.
   - Set the `storage_account_type` property to `"Standard_LRS"` for standard locally redundant storage.
   - Set the `caching` property to `"ReadWrite"` for read-write caching on the OS disk.

     ```hcl
     resource "azurerm_linux_virtual_machine" "server" {
        name                            = "vm-server"
        location                        = data.azurerm_resource_group.studentrg.location
        resource_group_name             = data.azurerm_resource_group.studentrg.name
        size                            = "Standard_B1ls"
        admin_username                  = var.admin_username
        disable_password_authentication = false
        admin_password                  = var.admin_password
        network_interface_ids           = [azurerm_network_interface.server.id]

        identity {
          type = "SystemAssigned"
        }

        boot_diagnostics {
           storage_account_uri = ""
        }

        source_image_reference {
          publisher = var.source_image_reference.publisher
          offer     = var.source_image_reference.offer
          sku       = var.source_image_reference.sku
          version   = var.source_image_reference.version
        }

        os_disk {
          storage_account_type = "Standard_LRS"
          caching              = "ReadWrite"
        }
      }
     ```

### Add output block

Last, but not least, we want our code to output some of the information we will get when deploying this, like IP address for the clients to connect to.

* Add the block below to the buttom of `01_deployclients.tf`

```hcl
output "client_connection_string" {
  value = { for client in local.clients : client => "ssh ${azurerm_linux_virtual_machine.client[client].admin_username}@${azurerm_linux_virtual_machine.client[client].public_ip_address}"
  }
}
```

* Add the block below to the buttom of `01_deployserver.tf`

```hcl
output "server_connection_string" {
  value = "ssh ${azurerm_linux_virtual_machine.server.admin_username}@${azurerm_linux_virtual_machine.server.private_ip_address}"
}
```

## Solution: 

If you encounter any issues or need to verify your configurations, refer to the `done` folder in the same directory for the solution.

**Initialize Terraform:**

In order for us to apply this into Azure we need to first initialize Terraform and see the plan:

``` terminal
terraform init
terraform plan
```

Now run `terraform apply` to apply the configuration code you made.

There will be a lot of resources created, and the output part should resemble this:

```plaintext
Apply complete! Resources: 12 added, 0 changed, 0 destroyed.

Outputs:

client_connection_string = {
  "client1" = "ssh Student-0@40.118.57.218"
  "client2" = "ssh Student-0@13.81.85.56"
}
```

### 5. Verify Connectivity and then Clean Up

After deploying the resources, verify connectivity by accessing the client VMs using SSH and ensure they can connect to the server VM.

Utilize the output connection strings provided in the Terraform output.

```plaintext
ssh Student-0@40.118.57.218
The authenticity of host '40.118.57.218 (40.118.57.218)' can't be established.
ECDSA key fingerprint is SHA256:WkvzYvfuAnJ1X6oVH91wxZKaXjp2W1YHiV5blEnCvH8.
Are you sure you want to continue connecting (yes/no/[fingerprint])?
```

Type 'yes'.

```plaintext
ssh Student-0@40.118.57.218
The authenticity of host '40.118.57.218 (40.118.57.218)' can't be established.
ECDSA key fingerprint is SHA256:WkvzYvfuAnJ1X6oVH91wxZKaXjp2W1YHiV5blEnCvH8.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '40.118.57.218' (ECDSA) to the list of known hosts.
Student-0@40.118.57.218's password:
```

Type in the password you have set during the resource creation.

```plaintext
$ ssh Student-0@40.118.57.218
The authenticity of host '40.118.57.218 (40.118.57.218)' can't be established.
ECDSA key fingerprint is SHA256:WkvzYvfuAnJ1X6oVH91wxZKaXjp2W1YHiV5blEnCvH8.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '40.118.57.218' (ECDSA) to the list of known hosts.
Student-0@40.118.57.218's password: 
Welcome to Ubuntu 22.04.4 LTS (GNU/Linux 6.5.0-1021-azure x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

 System information as of Thu May 23 13:43:32 UTC 2024

  System load:  0.09              Processes:             105
  Usage of /:   5.1% of 28.89GB   Users logged in:       0
  Memory usage: 62%               IPv4 address for eth0: 10.0.0.4
  Swap usage:   0%

Expanded Security Maintenance for Applications is not enabled.

0 updates can be applied immediately.

Enable ESM Apps to receive additional future security updates.
See https://ubuntu.com/esm or run: sudo pro status


The list of available updates is more than a week old.
To check for new updates run: sudo apt update


The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

Student-0@vm-client1:~$ 

```

Et voila, you are now connected to a virtual machine on Azure you just created with Terraform! You are awesome! 🎉

You can exit by either typing 'exit', or pressing Ctrl+D.

As the last thing, please remember to clean up your code deployed with `terraform destroy`.

**Extra Task: Visualizing the Terraform Dependency Graph**:

For those interested in visualizing how Terraform manages dependencies within your configuration, you can generate and view the dependency graph using the following commands:

1. Generate the graph in DOT format and save it to a file:

   ```shell
   terraform graph > graph.dot
   ```

2. Use GraphViz to convert the DOT file to a PNG image:

   ```shell
   dot -Tpng graph.dot -o graph.png
   ```

This will create a `graph.png` file, which visually represents the structure of your Terraform configuration. Open this file to review the relationships and dependencies between your resources.

## Congratulations 🎉 🎉

By completing this module, you've learned to set up and manage network configurations and VMs in Azure using Terraform, which is crucial for effective cloud infrastructure management.

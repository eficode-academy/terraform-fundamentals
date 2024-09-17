# 05(b)-Setup VM using Terraform

## Learning Goals

The 5th exercise is designed to be deployed in two parts - you have set up the network configurations as part of the previous exercise. Now you will deploy VMs over the network you provisioned using Terraform.

In this exercise, you will gain hands-on experience with Terraform to provision virtual machines (VMs) in Azure.

![exercise5(1)](https://github.com/eficode-academy/terraform-fundamentals/assets/71190161/4d1be400-4d33-46ac-a41c-d216605fb670)

## Objectives

* Deploy multiple client VMs with dynamic public IPs.
* Set up a server VM with a static public IP.
* Verify connectivity among deployed resources.
* Learn to clean up resources to avoid unnecessary charges.

## Step-by-Step Instructions

* Go to the folder `labs/05-Setup-VM-Using-Terraform/start`. That is where your exercise files should be created.

### 1. Deploy Client VMs

Now with the network created, we can focus on creating the configuration for the client.

#### a. Creating `01_deployclients.tf`

This file handles the deployment of client VMs. Dynamic public IPs are assigned to these VMs, allowing external access and connectivity tests.

1. **Go to the project directory**:
   - Navigate to `labs/05-Setup-VM-Using-Terraform/start` where your exercise files should be created.

2. **Create the `01_deployclients.tf` file**:
  
   - Create a new file named `01_deployclients.tf` in the `labs/05-Setup-VM-Using-Terraform/start` directory.

#### b. Configuration Steps for `01_deployclients.tf`

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

   - Define the `azurerm_public_ip` resource block named client.
   - Use `for_each` to loop over the `clients` local variable.
  
    ```hcl
     for_each = local.clients
     ```

   - Set the name property to ${each.key}-public-ip to include the client name..
   - Set the `location` and `resource_group_name` properties to use values from the Azure Resource Group data source.
      - (data.azurerm_resource_group.studentrg.location).
      - (data.azurerm_resource_group.studentrg.name).
   - Set the `allocation_method` to `"Dynamic"`.
   - Add tags with an `environment` set to `"Production"`.


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


### **Checkpoint **: Initialize, Plan, and Apply Client VM Deployment

Once you've configured the client VMs, initialize Terraform to include the new VM resources, then run the Terraform plan to verify the setup:

```bash
terraform init
terraform plan
```

After confirming the setup, deploy the client VMs:

```bash
terraform apply
```

### 2. Deploy Server VM

#### a. Creating `01_deployserver.tf`

This configuration sets up a server VM with a static public IP, ensuring that it has a fixed entry point for network communications, which is essential for server roles.

**Task Instructions:**

1. **Go to the project directory**:
   - Navigate to `labs/05-Setup-VM-Using-Terraform/start` where your exercise files should be created.

2. **Create the `01_deployserver.tf` file**:
   - Create a new file named `01_deployserver.tf` in the `labs/05-Setup-VM-Using-Terraform/start` directory.

#### b. Configuration Steps for `01_deployserver.tf`

1. **Define a Static Public IP for the Server**:
   - Create a `resource` block for `azurerm_public_ip` named `server`.
   - Set the `name` property to `"server-public-ip"` to clearly identify this IP as belonging to the server.
   - Set the `location` and `resource_group_name` properties to the same values used for other resources, ensuring consistency.
   - Use the `allocation_method` property set to `"Static"` to ensure the IP address remains consistent across restarts and redeployments.
   - Optionally, add tags such as `environment` with the value `"Production"` for organizational purposes.

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


### 3.Add output block

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

### 4. Verify Connectivity and then Clean Up

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

By completing this exercise, you've learned to set up and manage VMs in Azure using Terraform, which is crucial for effective cloud infrastructure management.

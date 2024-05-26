# 05-Setup VM Using Terraform.md

## Learning Goals

In this module, you will gain hands-on experience with Terraform to provision a virtual network and deploy virtual machines (VMs) in Azure. This exercise is designed to enhance your understanding of network configurations and VM deployment using Terraform.

## Objectives

* Create and configure a virtual network and subnets using Terraform.
* Deploy multiple client VMs with dynamic public IPs.
* Set up a server VM with a static public IP.
* Verify connectivity among deployed resources.
* Learn to clean up resources to avoid unnecessary charges.

## Step-by-Step Instructions

### 1 Introduction to Virtual Network Setup

A virtual network allows VMs and other resources to communicate with each other. The setup includes defining the network and subnet configurations to ensure proper isolation and address allocation.

### Define Variables in `variables.tf`

Before setting up your network configurations, it is essential to define the variables that will be used throughout your Terraform configurations. This will help in managing configurations effectively and maintaining modularity.

**Variable Declarations and Descriptions:**

```hcl
variable "exercise" {
  type        = string
  description = "This is the exercise number. It is used to make the name of some the resources unique"
}
```

```hcl
variable "network" {
  type = object({
    ranges = list(string)
  })
  default = {
    ranges = [
      "10.0.0.0/16"
    ]
  }
  description = "Subnet and address range for clients"
}
```

```hcl
variable "client_subnet" {
  type = object({
    name   = string
    ranges = list(string)
  })
  default = {
    name = "client"
    ranges = [
      "10.0.0.0/24"
    ]
  }
  description = "Subnet and address range for clients"
}
```

```hcl
variable "server_subnet" {
  type = object({
    name   = string
    ranges = list(string)
  })
  default = {
    name = "server"
    ranges = [
      "10.0.3.0/24"
    ]
  }
  description = "Subnet and address range for servers"
}
```

```hcl
variable "admin_password" {
  type        = string
  sensitive   = true
  description = "default password to connect to the servers we deploy"
}
```

```hcl
variable "admin_username" {
  type        = string
  sensitive   = false
  description = "default admin user to connect to the servers we deploy"
}
```

```hcl
variable "source_image_reference" {
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  default = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
  description = <<EOT
    "SKU details for the image to be deployed"
    EOT
}
```

**Using `variables.tf`:**

Place this file in your Terraform project directory alongside your main configuration files. Reference these variables in your configurations using `var.<variable_name>` to dynamically configure resources based on defined values.

### 2. Configure Network and Subnets

#### Creating `00_create_network.tf`

This configuration sets up the virtual network and associated subnets. This is crucial as it forms the foundational network infrastructure in which the VMs will operate.

**Resource Block `Virtual Network`:**

```hcl
terraform {}

resource "azurerm_virtual_network" "exercise5" {
  name                = "vnet-exercise5"
  resource_group_name = data.azurerm_resource_group.studentrg.name
  location            = data.azurerm_resource_group.studentrg.location
  address_space       = var.network.ranges
}
```

*This defines the virtual network in Azure where all your network resources will reside. It specifies the name, associated resource group, geographic location, and address space for the network.*

**Resource Block `Client Subnet`:**

```hcl
resource "azurerm_subnet" "client" {
  name                 = var.client_subnet.name
  resource_group_name  = data.azurerm_resource_group.studentrg.name
  virtual_network_name = azurerm_virtual_network.exercise5.name
  address_prefixes     = var.client_subnet.ranges
}
```

*This configures a subnet within the virtual network specifically for client VMs, detailing the subnet name, the resource group, which virtual network it belongs to, and the IP address range.*

**Resource Block `Server Subnet`:**

```hcl
resource "azurerm_subnet" "server" {
  name                 = var.server_subnet.name
  resource_group_name  = data.azurerm_resource_group.studentrg.name
  virtual_network_name = azurerm_virtual_network.exercise5.name
  address_prefixes     = var.server_subnet.ranges
}
```

*Similar to the client subnet, this configures a subnet for server VMs, specifying its unique characteristics within the same virtual network.*

### 3\. Deploy Client VMs

#### Creating `01_deployclients.tf`

This file handles the deployment of client VMs. Dynamic public IPs are assigned to these VMs, allowing external access and connectivity tests.

**Local Value: `Clients`:**

```hcl
locals {
  clients = toset(["client1", "client2"])
}
```

*Defines a local variable `clients` that stores the identifiers for the client VMs, facilitating their management through the `for_each` construct.*

**Resource Block `Public IP`:**

```hcl
resource "azurerm_public_ip" "client" {
  for_each            = local.clients
  name                = "${each.key}-public-ip"
  location            = data.azurerm_resource_group.studentrg.location
  resource_group_name = data.azurerm_resource_group.studentrg.name
  allocation_method   = "Dynamic"
  tags = {
    environment = "Production"
  }
}
```

*Creates a dynamic public IP for each client VM. It uses the `for_each` method to iterate over the `clients` local variable, ensuring each VM has its own public IP.*

**Resource Block `Network Interface`:**

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

*Defines a network interface for each client VM, which includes settings for internal networking, IP allocation, and association with the previously created public IP.*

**Resource Block `Virtual Machine`:**

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
  identity { type = "SystemAssigned" }
  boot_diagnostics { storage_account_uri = "" }
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

*Deploys a Linux virtual machine for each client using the network interface defined above. It specifies VM properties such as size, user credentials, associated network interfaces, and OS image details.*

### 4\. Deploy Server VM

#### Creating `01_deployserver.tf`

This configuration sets up a server VM with a static public IP, ensuring that it has a fixed entry point for network communications, which is essential for server roles.

**Resource Block `Public IP`:**

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

*Creates a static public IP for the server VM, ensuring it remains consistent across restarts and redeployments.*

**Resource Block `Network Interface`:**

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

*Configures the network interface for the server VM, linking it to the static public IP and ensuring it's part of the server subnet.*

**Resource Block `Virtual Machine`:**

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
  identity { type = "SystemAssigned" }
  boot_diagnostics { storage_account_uri = "" }
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

*Deploys the server VM, ensuring it is configured with the necessary credentials and linked to the network interface created earlier.*

### Add output block to 01_deployclients.tf

#### Output block that outputs the command to verify SSH connection to your newly created virtual machine

```hcl
output "client_connection_string" {
  value = { for client in local.clients : client => "ssh ${azurerm_linux_virtual_machine.client[client].admin_username}@${azurerm_linux_virtual_machine.client[client].public_ip_address}"
  }
}
```

**Initialize Terraform:**

 ```shell
terraform init
terraform plan
```

You will see the prompt where you have to enter some values manually:

The password can be anything, but has to be minimum 6 characters, has to have min 1 lower and 1 upper character, has a number in it, and one special condition other than "_".

There are also certain words that are reserved in Terraform, so you can use f.x your workstation name (Workstation-0, etc).

```plaintext
var.admin_password
  default password to connect to the servers we deploy

  Enter a value: 

var.admin_username
  default admin user to connect to the servers we deploy

  Enter a value: Student-0

var.exercise
  This is the exercise number. It is used to make the name of some the resources unique

  Enter a value: 7
```

**Apply Configuration:**

```shell
terraform apply
```

There will be a whole lot of resources created, and the output should resemble this:

```plaintext
Apply complete! Resources: 12 added, 0 changed, 0 destroyed.

Outputs:

client_connection_string = {
  "client1" = "ssh Student-0@40.118.57.218"
  "client2" = "ssh Student-0@13.81.85.56"
}
```

### 5. Verify Connectivity and Clean Up

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

Of course, to avoid incurring unnecessary charges, use the command `terraform destroy` to clean up all resources once you complete the exercises.

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

## Congratulations

By completing this module, you've learned to set up and manage network configurations and VMs in Azure using Terraform, which is crucial for effective cloud infrastructure management.

## Clean up

Please remember to clean up your code deployed with `terraform destroy`.

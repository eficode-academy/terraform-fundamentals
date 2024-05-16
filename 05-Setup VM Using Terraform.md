05-Setup VM Using Terraform.md
==============================

Learning Goals
--------------

In this module, you will gain hands-on experience with Terraform to provision a virtual network and deploy virtual machines (VMs) in Azure. This exercise is designed to enhance your understanding of network configurations and VM deployment using Terraform.

Objectives
----------

* Create and configure a virtual network and subnets using Terraform.
* Deploy multiple client VMs with dynamic public IPs.
* Set up a server VM with a static public IP.
* Verify connectivity among deployed resources.
* Learn to clean up resources to avoid unnecessary charges.

Step-by-Step Instructions
-------------------------

### 1\. Introduction to Virtual Network Setup

A virtual network allows VMs and other resources to communicate with each other. The setup includes defining the network and subnet configurations to ensure proper isolation and address allocation.

### Define Variables in `variables.tf`

Before setting up your network configurations, it is essential to define the variables that will be used throughout your Terraform configurations. This will help in managing configurations effectively and maintaining modularity.

**Variable Declarations and Descriptions:**

```
variable "exercise" {
  type        = string
  description = "This is the exercise number. It is used to make the name of some the resources unique"
}

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

variable "admin_password" {
  type        = string
  sensitive   = true
  description = "default password to connect to the servers we deploy"
}

variable "admin_username" {
  type        = string
  sensitive   = false
  description = "default admin user to connect to the servers we deploy"
}

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

**Using `variables.tf`:** Place this file in your Terraform project directory alongside your main configuration files. Reference these variables in your configurations using `var.<variable_name>` to dynamically configure resources based on defined values.

### 2\. Configure Network and Subnets

#### Creating `00_create_network.tf`:

This configuration sets up the virtual network and associated subnets. This is crucial as it forms the foundational network infrastructure in which the VMs will operate.

**Configuration Explained:**

**Resource Block: Virtual Network**

```
resource "azurerm_virtual_network" "exercise5" {
  name                = "vnet-exercise5"
  resource_group_name = data.azurerm_resource_group.studentrg.name
  location            = data.azurerm_resource_group.studentrg.location
  address_space       = var.network.ranges
}
```

*This defines the virtual network in Azure where all your network resources will reside. It specifies the name, associated resource group, geographic location, and address space for the network.*

**Resource Block: Client Subnet**

```
resource "azurerm_subnet" "client" {
  name                 = var.client_subnet.name
  resource_group_name  = data.azurerm_resource_group.studentrg.name
  virtual_network_name = azurerm_virtual_network.exercise5.name
  address_prefixes     = var.client_subnet.ranges
}
```

*This configures a subnet within the virtual network specifically for client VMs, detailing the subnet name, the resource group, which virtual network it belongs to, and the IP address range.*

**Resource Block: Server Subnet**

```
resource "azurerm_subnet" "server" {
  name                 = var.server_subnet.name
  resource_group_name  = data.azurerm_resource_group.studentrg.name
  virtual_network_name = azurerm_virtual_network.exercise5.name
  address_prefixes     = var.server_subnet.ranges
}
```

*Similar to the client subnet, this configures a subnet for server VMs, specifying its unique characteristics within the same virtual network.*

**Initialize Terraform**: Prepares your project for Terraform operations.

 ```
terraform init
 ```

```
terraform plan
```

**Apply Configuration**: Executes the plan to create resources.

```
terraform apply
```

### 3\. Deploy Client VMs

#### Creating `01-deployclients.tf`:

**Purpose of Configuration:**

This file handles the deployment of client VMs. Dynamic public IPs are assigned to these VMs, allowing external access and connectivity tests.

**Configuration Explained:**

**Local Value: Clients**

```
locals {
  clients = toset(["client1", "client2"])
}
```

*Defines a local variable `clients` that stores the identifiers for the client VMs, facilitating their management through the `for_each` construct.*

**Resource Block: Public IP**

```
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

**Resource Block: Network Interface**

```
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

**Resource Block: Virtual Machine**

```
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

#### Creating `01-deployserver.tf`:

**Purpose of Configuration:**

This configuration sets up a server VM with a static public IP, ensuring that it has a fixed entry point for network communications, which is essential for server roles.

**Configuration Explained:**

**Resource Block: Public IP**

```
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

**Resource Block: Network Interface**

```
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

**Resource Block: Virtual Machine**

```
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

### 5. Verify Connectivity and Clean Up

After deploying the resources, verify connectivity by accessing the client VMs using SSH and ensure they can connect to the server VM. Utilize the output connection strings provided in the Terraform output.

To avoid incurring unnecessary charges, use the command `terraform destroy` to clean up all resources once you complete the exercises.

Certainly! To provide clear instructions for generating and visualizing the Terraform dependency graph, you can frame it as an optional additional task within your documentation like this:

**Extra Task: Visualizing the Terraform Dependency Graph**:

For those interested in visualizing how Terraform manages dependencies within your configuration, you can generate and view the dependency graph using the following commands:

1. Generate the graph in DOT format and save it to a file:
   ```bash
   terraform graph > graph.dot
   ```

2. Use GraphViz to convert the DOT file to a PNG image:
   ```bash
   dot -Tpng graph.dot -o graph.png
   ```

This will create a `graph.png` file, which visually represents the structure of your Terraform configuration. Open this file to review the relationships and dependencies between your resources.


Conclusion
----------

Congratulations! By completing this module, you've learned to set up and manage network configurations and VMs in Azure using Terraform, which is crucial for effective cloud infrastructure management.

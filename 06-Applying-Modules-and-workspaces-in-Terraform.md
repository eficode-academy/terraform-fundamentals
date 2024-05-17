06-Applying Modules and Workspaces in Terraform.md
==================================================

Learning Goals
--------------

This module provides an opportunity to master the use of Terraform modules and workspaces by creating a scalable and repeatable infrastructure with virtual machines (VMs) in Azure. Learn how to deploy VMs based on YAML configurations, emphasizing the flexibility and reusability of Terraform modules.

Objectives
----------

*  Understand the use of Terraform modules for resource deployment.
*  Learn to interpret and apply configurations from YAML files.
*  Deploy three virtual machines using the `for_each` construct to loop over configurations.
*  Utilize Terraform workspaces to manage different deployment environments or stages.
*  Clean up resources to prevent unnecessary Azure charges.

Step-by-Step Instructions
-------------------------

### 1\. Overview of Modules and Workspaces

Terraform modules allow you to encapsulate and reuse code for creating groups of related resources. Workspaces enable you to maintain state files separately for the same configuration, providing a way to manage different environments (like staging and production) from the same configuration.

### 2\. Define Variables in `variables.tf`

Before diving into the actual Terraform configurations, it's crucial to define the variables that will be used throughout your project. This setup enhances modularity and flexibility, allowing parameters to be easily adjusted or reused across different environments.

**Variable Definitions:**

``` 
variable "exercise" {
  type        = string
  description = "This is the exercise number. It is used to make the name of some the resources unique"
}
```
```
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
```
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
```
variable "admin_password" {
  type        = string
  sensitive   = true
  description = "default password to connect to the servers we deploy"
}
```
```
variable "admin_username" {
  type        = string
  sensitive   = true
  description = "default admin user to connect to the servers we deploy"
}
```

### 3\. Prepare Configuration Files

Ensure you have the YAML configuration files ready as described:

#### `instances.yaml`

``` 
data:
  client1:
    size: "Standard_B1ls"
    public_ip: true
    subnet: client
  client2:
    size: "Standard_B1ls"
    public_ip: true
    subnet: client
  server:
    size: "Standard_B1ls"
    public_ip: false
    subnet: server
```

#### `network.yaml`

``` 
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
```

These files are located in the `configuration` folder.

### 4\. Create Network Resources

#### Creating `00_createnetwork.tf`:

This file sets up the virtual network and associated subnets using data from `network.yaml`, laying the foundation for the VM deployments.

**Local Block: Network Data**

``` 
locals {
  yaml_network_data = yamldecode(file("${path.root}/${var.network_configuration}"))
  network           = local.yaml_network_data["data"]
}
```

**Resource Block: Virtual Network**

``` 
resource "azurerm_virtual_network" "main" {
  name                = "vnet-${var.exercise}"
  resource_group_name = data.azurerm_resource_group.studentrg.name
  location            = data.azurerm_resource_group.studentrg.location
  address_space       = local.network.ranges
}
```

**Resource Block: Subnet**

```
resource "azurerm_subnet" "main" {
  for_each            = local.network.subnets
  name                = each.key
  resource_group_name = data.azurerm_resource_group.studentrg.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes    = each.value.ranges
}
```

### 5\. Initialize and Plan Deployment

**Initialize your Terraform environment to prepare the backend and install required providers:**

```terraform init```

**Review the planned actions by Terraform without applying them:**

```terraform plan```

### 6\. Deploy Virtual Machines

#### Creating `01_createinstances.tf`:

This file deploys VMs based on configurations specified in `instances.yaml` using a Terraform module for VM creation.

**Local Block: VM Instances**

```
locals {
  yaml_vms_data = yamldecode(file("${path.root}/${var.instances_configuration}"))
  instances     = local.yaml_vms_data["data"]
}
```

**Resource Block: Public IP**

``` hcl
resource "azurerm_public_ip" "pip" {
  for_each = { for vm, config in local.instances : vm => config if config.public_ip }
  name                = "${each.key}-public-ip"
  location            = data.azurerm_resource_group.studentrg.location
  resource_group_name = data.azurerm_resource_group.studentrg.name
  allocation_method   = "Dynamic"
  tags = {
    environment = each.key
  }
}
```

**Module Block: Virtual Machine**

``` 
module "virtual-machine" {
  for_each = local.instances

  source                     = "Azure/virtual-machine/azurerm"
  version                    = "1.1.0"
  location                   = data.azurerm_resource_group.studentrg.location
  resource_group_name        = data.azurerm_resource_group.studentrg.name
  image_os                   = "linux"
  allow_extension_operations = false
  new_boot_diagnostics_storage_account = {}
  new_network_interface = {
    ip_forwarding_enabled = false
    ip_configurations = [
      {
        public_ip_address_id = try(azurerm_public_ip.pip[each.key].id, null)
        primary              = true
      }
    ]
  }
  admin_username                  = var.admin_username
  disable_password_authentication = false
  admin_password                  = var.admin_password
  name                            = each.key
  os_disk = {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  os_simple = "UbuntuServer"
  size      = each.value.size
  subnet_id = azurerm_subnet.main[each.value.subnet].id
  tags = {
    environment = each.key
  }
}
```

### 7\. Verify and Clean Up

After deploying the resources, verify the VMs' functionality by accessing them as needed. Ensure they are operating within the correct network and accessible per your configuration

To manage costs effectively and avoid unnecessary charges in Azure:

```terraform destroy```

This command cleans up all resources deployed during this exercise.

Conclusion
----------

Congratulations! You've successfully utilized Terraform modules and workspaces to deploy and manage virtual machines in Azure. This exercise demonstrates the power of Terraform in managing complex infrastructure setups efficiently and repeatably.

# 06-Applying Modules and Workspaces in Terraform.md

## Learning Goals

This module provides an opportunity to master the use of Terraform modules and workspaces by creating a scalable and repeatable infrastructure with virtual machines (VMs) in Azure. Learn how to deploy VMs based on YAML configurations, emphasizing the flexibility and reusability of Terraform modules.

## Objectives

1\. Understand the use of Terraform modules for resource deployment.\
2\. Learn to interpret and apply configurations from YAML files.\
3\. Deploy three virtual machines using the for_each construct to loop over configurations.\
4\. Utilize Terraform workspaces to manage different deployment environments or stages.\
5\. Clean up resources to prevent unnecessary Azure charges.

## Step-by-Step Instructions

### 1. Overview of Modules and Workspaces

Terraform modules allow you to encapsulate and reuse code for creating groups of related resources. Workspaces enable you to maintain state files separately for the same configuration, providing a way to manage different environments (like staging and production) from the same configuration.

### 2. Prepare Configuration Files

Ensure you have the YAML configuration files ready as described:

- **instances.yaml** - Specifies the details of the virtual machines to deploy.
- **network.yaml** - Defines the network configurations such as address spaces and subnets.

These files are located in the `configuration` folder.

### 3. Create Network Resources

**Create `00_createnetwork.tf`**:

This file will set up the virtual network and associated subnets using the data pulled from `network.yaml`:

```
locals {
  yaml_network_data = yamldecode(file("${path.root}/${var.network_configuration}"))
  network           = local.yaml_network_data["data"]
}

resource "azurerm_virtual_network" "main" {
  name                = "vnet-${var.exercise}"
  resource_group_name = data.azurerm_resource_group.studentrg.name
  location            = data.azurerm_resource_group.studentrg.location
  address_space       = local.network.ranges
}

resource "azurerm_subnet" "main" {
  for_each             = local.network.subnets
  name                 = each.key
  resource_group_name  = data.azurerm_resource_group.studentrg.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = each.value.ranges
}
```

### 4. Initialize and Plan Deployment

Initialize your Terraform environment to prepare the backend and install required providers:

```
terraform init
```

Review the planned actions by Terraform without applying them:

```
terraform plan
```

### 5. Deploy Virtual Machines

**Create `01_createinstances.tf`**:

This file deploys VMs based on the configurations specified in `instances.yaml` using a Terraform module for VM creation:

```
locals {
  yaml_vms_data = yamldecode(file("${path.root}/${var.instances_configuration}"))
  instances     = local.yaml_vms_data["data"]
}

resource "azurerm_public_ip" "pip" {
  for_each = { for vm, config in local.instances : vm => config if config.public_ip }
  name                = "${each.key}-public-ip"
  location            = data.azurerm_resource_group.studentrg.location
  resource_group_name = data.azurerm_resource_group.studentrg.name
  allocation_method   = "Dynamic"
  tags = {
    environment = each.key
  }
}

module "virtual-machine" {
  for_each = local.instances

  source                     = "Azure/virtual-machine/azurerm"
  version                    = "1.1.0"
  location                   = data.azurerm_resource_group.studentrg.location
  resource_group_name        = data.azurerm_resource_group.studentrg.name
  image_os                   = "linux"
  allow_extension_operations = false
  new_boot_diagnostics_storage_account = {}
  new_network_interface = {
    ip_forwarding_enabled = false
    ip_configurations = [
      {
        public_ip_address_id = try(azurerm_public_ip.pip[each.key].id, null)
        primary              = true
      }
    ]
  }
  admin_username                  = var.admin_username
  disable_password_authentication = false
  admin_password                  = var.admin_password
  name                            = each.key
  os_disk = {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  os_simple = "UbuntuServer"
  size      = each.value.size
  subnet_id = azurerm_subnet.main[each.value.subnet].id
  tags = {
    environment = each.key
  }
}
```

# Apply configuration
```
terraform apply
```

### 6. Verify and Clean Up

After deploying the resources, verify the VMs' functionality by accessing them as needed. Ensure they are operating within the correct network and accessible per your configurations.

To manage costs effectively and avoid unnecessary charges in Azure:

```
terraform destroy
```

This command cleans up all resources deployed during this exercise.

## Conclusion

Congratulations! You've successfully utilized Terraform modules and workspaces to deploy and manage virtual machines in Azure. This exercise demonstrates the power of Terraform in managing complex infrastructure setups efficiently and repeatably.

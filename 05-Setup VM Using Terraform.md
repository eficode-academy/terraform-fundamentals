05-Setup VM Using Terraform.md
==============================

Learning Goals
--------------

In this module, you will gain hands-on experience with Terraform to provision a virtual network and deploy virtual machines (VMs) in Azure. This exercise is designed to enhance your understanding of network configurations and VM deployment using Terraform.

Objectives
----------

1.  Create and configure a virtual network and subnets using Terraform.
2.  Deploy multiple client VMs with dynamic public IPs.
3.  Set up a server VM with a static public IP.
4.  Verify connectivity among deployed resources.
5.  Learn to clean up resources to avoid unnecessary charges.

Step-by-Step Instructions
-------------------------

### 1\. Introduction to Virtual Network Setup

A virtual network allows VMs and other resources to communicate with each other. The setup includes defining the network and subnet configurations to ensure proper isolation and address allocation.

### 2\. Configure Network and Subnets

**Create `00_create_network.tf`**:

Define your virtual network and subnets in Azure using the following configurations:

```
resource "azurerm_virtual_network" "exercise5" {
  name                = "vnet-exercise5"
  resource_group_name = data.azurerm_resource_group.studentrg.name
  location            = data.azurerm_resource_group.studentrg.location
  address_space       = var.network.ranges
}

resource "azurerm_subnet" "client" {
  name                 = var.client_subnet.name
  resource_group_name  = data.azurerm_resource_group.studentrg.name
  virtual_network_name = azurerm_virtual_network.exercise5.name
  address_prefixes     = var.client_subnet.ranges
}

resource "azurerm_subnet" "server" {
  name                 = var.server_subnet.name
  resource_group_name  = data.azurerm_resource_group.studentrg.name
  virtual_network_name = azurerm_virtual_network.exercise5.name
  address_prefixes     = var.server_subnet.ranges
}
```

Before applying any changes, initialize your Terraform environment:

`terraform init`

This command sets up your Terraform to work with the specified providers and modules.

Next, plan your deployment to see what Terraform will do:

`terraform plan`

This command shows the changes that will be made to your infrastructure.

Apply configuration

`terraform apply`

### 3\. Deploy Client VMs

**Create `01-deployclients.tf`**:

Deploy client VMs with dynamic public IPs. Use the following Terraform configurations:

```
locals {
  clients = toset(["client1", "client2"])
}

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

Apply configuration

`terraform apply`

### 4\. Deploy Server VM

**Create `01-deployserver.tf`**:

Set up a server VM with a static public IP and verify the configurations as follows:

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

Apply configuration

`terraform apply`

### 5\. Verify Connectivity and Clean Up

After deploying the resources, verify connectivity by accessing the client VMs using SSH and ensure they can connect to the server VM. Utilize the output connection strings provided in the Terraform output.

To avoid incurring unnecessary charges, use the command `terraform destroy` to clean up all resources once you complete the exercises.

Conclusion
----------

Congratulations! By completing this module, you've learned to set up and manage network configurations and VMs in Azure using Terraform, which is crucial for effective cloud infrastructure management.

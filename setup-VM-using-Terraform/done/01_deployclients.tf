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

    # TODO: make public_ip depends on the input var
    public_ip_address_id = azurerm_public_ip.client[each.key].id
  }
  depends_on = [azurerm_subnet.client]
}

resource "azurerm_linux_virtual_machine" "client" {
  for_each                        = local.clients
  name                            = "vm-${each.key}"
  location                        = data.azurerm_resource_group.studentrg.location
  resource_group_name             = data.azurerm_resource_group.studentrg.name
  size                            = "Standard_B1ls" #Standard_B1s
  admin_username                  = var.admin_username
  disable_password_authentication = false
  admin_password                  = var.admin_password
  #custom_data                     = data.cloudinit_config.ca-config.rendered
  network_interface_ids = [azurerm_network_interface.client[each.key].id]
  identity {
    type = "SystemAssigned"
  }

  boot_diagnostics {
    storage_account_uri = ""
  }

  # az vm image list --publisher Canonical
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

/*
output "client_connection_string" {
  value = "ssh ${azurerm_linux_virtual_machine.client.admin_username}@${azurerm_public_ip.client.ip_address}"  
}
*/
output "client_connection_string" {
  value = { for client in local.clients : client => "ssh ${azurerm_linux_virtual_machine.client[client].admin_username}@${azurerm_linux_virtual_machine.client[client].public_ip_address}"
  }
}

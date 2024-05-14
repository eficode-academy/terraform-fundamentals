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

    # TODO: make public_ip depends on the input var
    public_ip_address_id = azurerm_public_ip.server.id
  }
  depends_on = [azurerm_subnet.server]
}

resource "azurerm_linux_virtual_machine" "server" {
  name                            = "vm-server"
  location                        = data.azurerm_resource_group.studentrg.location
  resource_group_name             = data.azurerm_resource_group.studentrg.name
  size                            = "Standard_B1ls" #Standard_B1s
  admin_username                  = var.admin_username
  disable_password_authentication = false
  admin_password                  = var.admin_password
  #custom_data                     = data.cloudinit_config.ca-config.rendered
  network_interface_ids = [azurerm_network_interface.server.id]
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


output "server_connection_string" {
  value = "ssh ${azurerm_linux_virtual_machine.server.admin_username}@${azurerm_linux_virtual_machine.server.private_ip_address}"
}

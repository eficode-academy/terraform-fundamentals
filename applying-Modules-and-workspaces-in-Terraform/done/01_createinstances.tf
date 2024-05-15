locals {
  yaml_vms_data = yamldecode(file("${path.root}/${var.instances_configuration}"))
  instances     = local.yaml_vms_data["data"]
}

resource "azurerm_public_ip" "pip" {
  # Only include instances in the for_each where 'public_ip' is true
  for_each = { for vm, config in local.instances : vm => config if config.public_ip }

  name                = "${each.key}-public-ip"
  location            = data.azurerm_resource_group.studentrg.location
  resource_group_name = data.azurerm_resource_group.studentrg.name
  allocation_method   = "Dynamic"

  tags = {
    environment = each.key
  }
}

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
        # will pass the first non null value
        public_ip_address_id = try(azurerm_public_ip.pip[each.key].id, null)
        primary              = true
      }
    ]
  }
  admin_username                  = var.admin_username
  disable_password_authentication = false
  admin_password                  = var.admin_password

  name = each.key
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


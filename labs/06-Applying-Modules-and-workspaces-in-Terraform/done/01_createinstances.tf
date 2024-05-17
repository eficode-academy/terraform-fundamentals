locals {
  yaml_vms_data = yamldecode(file("${path.root}/${var.instances_configuration}"))
  instances     = local.yaml_vms_data["data"]
  /*
  As before, we decode the yaml data, creating a data structure we can work with
  */
}

resource "azurerm_public_ip" "pip" {
  /*
  for expressions in terraform generate tuples (immutable lists) or objects, depending on the external parenthesis
  For example:
  var.list = [ 
              "baz",
              "foo",
              ]
  result = [ for value in var.list : upper(value) ]
  then:
    result is  ["BAZ", "FOO"]

  instead if:
  result = { for value in var.list : value => upper(value) }
  then:
    result is  {baz = "BAZ", foo = "FOO"}

  finally if:
  var.object = { 
              a = "baz",
              b = "fooo",
              }
  result = { for key, value in var.object : key => length(value) ]
then:
    result is  {a = 3, b = 4 }

For further info see:
https://developer.hashicorp.com/terraform/language/expressions/for#result-types
*/
  for_each = { for vm, config in local.instances : vm => config if config.public_ip }

  name                = "${each.key}-public-ip"
  location            = data.azurerm_resource_group.studentrg.location
  resource_group_name = data.azurerm_resource_group.studentrg.name
  allocation_method   = "Dynamic"

  tags = {
    environment = each.key
  }
}

/*
Here we use a module to abstract the creation of virtual machines
In this example, compared to the previous exercise, the creation of the virtual machine network card is abstracted away
The configuration is also streamlined.

Best of all, this module is maintained by microsoft! This will make our deployment easier to maintain as Azure evolves in time
Always check the official terraform registry for official modules you can leverage
https://registry.terraform.io/

*/
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
        /*
        # the try() function will evaluate to the first non null value
        See also: https://developer.hashicorp.com/terraform/language/functions/try

        If an attribute is set to null terraform (not empty string!) terraform will consider it omitted
        See also: https://developer.hashicorp.com/terraform/language/expressions/types#null 
        */
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


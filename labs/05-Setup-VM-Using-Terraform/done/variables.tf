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
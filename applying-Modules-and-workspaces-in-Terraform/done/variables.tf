variable "exercise" {
  type        = string
  description = "This is the exercise number. It is used to make the name of some the resources unique"
}

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

variable "admin_password" {
  type        = string
  sensitive   = true
  description = "default password to connect to the servers we deploy"
}

variable "admin_username" {
  type        = string
  sensitive   = true
  description = "default admin user to connect to the servers we deploy"
}

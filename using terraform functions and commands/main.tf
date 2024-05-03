terraform {
  required_version = "~> 1.3.0"  # Specifies the required Terraform version
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
  }
}

resource "random_string" "randomname" {
  length  = 16
  count   = 2
  special = false
  upper   = false
}

output "random_string_values" {
  value = random_string.randomname.*.result
  description = "The generated random strings."
}
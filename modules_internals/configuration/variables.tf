variable "workstationname" {
  type        = string
  nullable    = true
  default     = "terraform-fundamentals"
  description = "Will be used to set the resource group to be used for the exercise. It will be returned as rg-{lower(resource-group)}"
}

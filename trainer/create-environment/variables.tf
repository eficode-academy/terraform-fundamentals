variable "number_of_students" {
  type        = number
  default     = 2
  description = "How many students"
  validation {
    condition     = tonumber(var.number_of_students) == floor(var.number_of_students)
    error_message = "Release should be a positive integer!"
  }
}

variable "password" {
  type        = string
  description = "Password to be used for student accounts"
  sensitive   = true
}

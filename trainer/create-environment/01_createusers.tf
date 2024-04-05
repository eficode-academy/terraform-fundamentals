resource "azuread_user" "example" {
  count               = var.number_of_students
  user_principal_name = "student${count.index}@eficodetraining.onmicrosoft.com"
  display_name        = "Student ${count.index}"
  password            = "SecretP@sswd99!"
}
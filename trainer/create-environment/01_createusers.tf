resource "azuread_user" "example" {
  count               = var.number_of_students
  user_principal_name = "workstation-${count.index + 1}@eficodetraining.onmicrosoft.com"
  display_name        = "Workstation ${count.index + 1}"
  password            = var.password
}
resource "azuread_user" "example" {
  count               = var.number_of_students
  user_principal_name = "${local.userid[count.index]}@eficodetraining.onmicrosoft.com"
  display_name        = "Workstation ${count.index}"
  password            = var.password
}
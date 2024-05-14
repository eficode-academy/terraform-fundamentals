# List all users we created
output users {
    value = [for user in azuread_user.example: user.user_principal_name ]
}
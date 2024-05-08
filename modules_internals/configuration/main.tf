output "studentname" {
  value = lower(var.workstationname)
}
output "rgname" {
  value = "rg-${lower(var.workstationname)}"
}

output "location" {
  value = lower(local.location)
}
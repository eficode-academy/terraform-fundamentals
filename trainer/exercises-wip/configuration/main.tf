output studentname {
    value = "${lower(local.studentname)}"
}

output rgname {
    value = "rg-${lower(local.studentname)}"
}

output location {
    value = "rg-${lower(local.location)}"
}
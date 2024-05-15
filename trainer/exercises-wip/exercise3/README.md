## Overview

## User Password
No User password is provided by default.
You can create a secrets.auto.tfvars file in this folder and add:
```
password = "mysecretpasswordhere"
```
Alternatively you can set the following environment variable:
TF_VAR_password = "mysecretpasswordhere" 

## Terraform State

Accessing terraform state requires you to be a member of the azure "Eficodeans" group
Also you need to install azure cli and run

```
az login
```

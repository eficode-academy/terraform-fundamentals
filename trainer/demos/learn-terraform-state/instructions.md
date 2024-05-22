Apply the initial configuration to create resources:

```
terraform init

terraform plan

terraform apply

```

This will create the resource group and virtual network as defined in the configuration.

Delete the terraform.tfstate and terraform.tfstate.backup files to simulate losing the Terraform state.

```

rm terraform.tfstate terraform.tfstate.backup

```

Now if you try to run 

```
terraform plan

```

you can observe that Terraform will have no knowledge of the already existing resources on Azure and suggest to recreate them. 

But we don't want to recreate them again! So how to fix?

Import existing resources into Terraform:

Make sure your main.tf file still contains the resource definitions you used to create the resources.

Then, import the resources using the terraform import command.

```
terraform init

terraform import azurerm_resource_group.rg /subscriptions/<subscription_id>/resourceGroups/terraform-simple-rg

terraform import azurerm_virtual_network.vnet /subscriptions/<subscription_id>/resourceGroups/terraform-simple-rg/providers/Microsoft.Network/virtualNetworks/simple-vnet
```

Replace <subscription_id> with your actual Azure subscription ID, which you can get by running

```
az account show
```

Verify the imported resources:

Run terraform plan to ensure that Terraform recognizes the imported resources correctly. It should not show any changes if the import was successful.

```
terraform plan
```

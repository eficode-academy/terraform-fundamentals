**Manage Workspaces**:

**List Workspaces**: List all available workspaces.

```
terraform workspace list
```

**Create a New Workspace**: Create a new workspace named `dev`.

```
terraform workspace new dev
```

**Create Another Workspace**: Create another workspace named `prod`.

```
terraform workspace new prod
```

**Select a Workspace**: Switch to the `dev` workspace.

```
terraform workspace select dev
```

**Select Another Workspace**: Switch to the `prod` workspace.

```
terraform workspace select prod
```

**Provision Resources**:

**In `dev` Workspace**: Select the `dev` workspace and apply the configuration.

```
terraform workspace select dev
terraform apply -auto-approve
```

This will create a resource group named `dev-rg`.

**In `prod` Workspace**: Select the `prod` workspace and apply the configuration.

```
terraform workspace select prod
terraform apply -auto-approve
```

This will create a resource group named `prod-rg`.

**Cleanup Resources**:

**Destroy Resources in `dev` Workspace**: Select the `dev` workspace and destroy the resources.

```
terraform workspace select dev
terraform destroy -auto-approve
```

**Destroy Resources in `prod` Workspace**: Select the `prod` workspace and destroy the resources.

```
terraform workspace select prod
terraform destroy -auto-approve
```

**Delete Workspaces**:

**Delete `dev` Workspace**: Delete the `dev` workspace.

```
terraform workspace select default
terraform workspace delete dev
```

**Delete `prod` Workspace**: Delete the `prod` workspace.

```
terraform workspace select default
terraform workspace delete prod
```

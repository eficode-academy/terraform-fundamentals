# 01-Terraform Basic Commands

## Learning Goals
- Execute the basic Terraform commands: `terraform init`, `terraform plan`, and `terraform apply`
- Observe how they function in managing infrastructure

## Introduction
This exercise provides an introduction to the basics commands of Terraform through the setup and deployment of a Flask application. 

You will directly apply the basic Terraform commands, observe the changes each command makes, and understand their roles in the workflow of infrastructure as code.

### Flask Application
The application consists of three components: `frontend`, `backend`, and a `database`. 

The frontend and backend are small python Flask webservers that listen for HTTP requests. 
For persistent storage, a postgresql database is used.

The basic functionality of the application can be achieved by deploying the frontend alone. 
The frontend listens for HTTP requests on port `5000` (the default for Flask).

### Terraform Configuration
The Terraform configuration in the [labs/01-terraform-basic-commands](https://github.com/eficode-academy/terraform-fundamentals/tree/main/labs/01-terraform-basic-commands) directory is set to define and provision the necessary cloud infrastructure to run the Flask application.

It typically includes server setup, networking, and security settings.

In this exercise, we will only be deploying the frontend of the Flask app.

## Step-by-Step Instructions

### 1. Initialize Your Terraform Workspace

Navigate to the `terraform basic commands` directory within your project.

`cd labs/01-terraform-basic-commands/`

Initialize the Terraform workspace to prepare your environment:

`terraform init`

The output should resemble the example shown below.

```
coder@workstation-3 ~/terraform-fundamentals/terraform-basic-commands (main *)
$ terraform init

Initializing the backend...

Successfully configured the backend "local"! Terraform will automatically
use this backend unless the backend configuration changes.
Initializing modules...
- exerciseconfiguration in ../modules_internals/configuration

Initializing provider plugins...
- Finding hashicorp/local versions matching "~> 2.4.0"...
- Finding latest version of hashicorp/random...
- Finding hashicorp/azurerm versions matching "~> 3.98.0"...
- Installing hashicorp/random v3.6.1...
- Installed hashicorp/random v3.6.1 (signed by HashiCorp)
- Installing hashicorp/azurerm v3.98.0...
- Installed hashicorp/azurerm v3.98.0 (signed by HashiCorp)
- Installing hashicorp/local v2.4.1...
- Installed hashicorp/local v2.4.1 (signed by HashiCorp)

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.

```

This command sets up Terraform, installing any required provider plugins and setting up the backend for state management.

### 2. Plan Your Deployment

Generate an execution plan to preview the actions Terraform will take based on the configurations

`terraform plan`

The output should resemble the example shown below.

```
coder@workstation-3 ~/terraform-fundamentals/terraform-basic-commands (main *)
$ terraform plan
data.azurerm_resource_group.studentrg: Reading...
data.azurerm_resource_group.studentrg: Read complete after 0s [id=/subscriptions/769d8f7e-e398-4cbf-8014-0019e1fdee59/resourceGroups/rg-workstation-3]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # azurerm_linux_web_app.webapp will be created
  + resource "azurerm_linux_web_app" "webapp" {
      + client_affinity_enabled                        = false
      + client_certificate_enabled                     = false
      + client_certificate_mode                        = "Required"
      + custom_domain_verification_id                  = (sensitive value)
      + default_hostname                               = (known after apply)
      + enabled                                        = true
      + ftp_publish_basic_authentication_enabled       = true
      + hosting_environment_id                         = (known after apply)
      + https_only                                     = true
      + id                                             = (known after apply)
      + key_vault_reference_identity_id                = (known after apply)
      + kind                                           = (known after apply)
      + location                                       = "westeurope"
      + name                                           = (known after apply)
      + outbound_ip_address_list                       = (known after apply)
      + outbound_ip_addresses                          = (known after apply)
      + possible_outbound_ip_address_list              = (known after apply)
      + possible_outbound_ip_addresses                 = (known after apply)
      + public_network_access_enabled                  = true
      + resource_group_name                            = "rg-workstation-3"
      + service_plan_id                                = (known after apply)
      + site_credential                                = (sensitive value)
      + webdeploy_publish_basic_authentication_enabled = true
      + zip_deploy_file                                = (known after apply)

      + site_config {
          + always_on                               = false
          + container_registry_use_managed_identity = false
          + default_documents                       = (known after apply)
          + detailed_error_logging_enabled          = (known after apply)
          + ftps_state                              = "Disabled"
          + health_check_eviction_time_in_min       = (known after apply)
          + http2_enabled                           = false
          + ip_restriction_default_action           = "Allow"
          + linux_fx_version                        = (known after apply)
          + load_balancing_mode                     = "LeastRequests"
          + local_mysql_enabled                     = false
          + managed_pipeline_mode                   = "Integrated"
          + minimum_tls_version                     = "1.2"
          + remote_debugging_enabled                = false
          + remote_debugging_version                = (known after apply)
          + scm_ip_restriction_default_action       = "Allow"
          + scm_minimum_tls_version                 = "1.2"
          + scm_type                                = (known after apply)
          + scm_use_main_ip_restriction             = false
          + use_32_bit_worker                       = true
          + vnet_route_all_enabled                  = false
          + websockets_enabled                      = false
          + worker_count                            = (known after apply)

          + application_stack {
              + docker_image_name        = "eficode-academy/quotes-flask-frontend:release"
              + docker_registry_password = (sensitive value)
              + docker_registry_url      = "https://ghcr.io"
              + docker_registry_username = (known after apply)
            }
        }
    }

  # azurerm_service_plan.example will be created
  + resource "azurerm_service_plan" "example" {
      + id                           = (known after apply)
      + kind                         = (known after apply)
      + location                     = "westeurope"
      + maximum_elastic_worker_count = (known after apply)
      + name                         = "example"
      + os_type                      = "Linux"
      + per_site_scaling_enabled     = false
      + reserved                     = (known after apply)
      + resource_group_name          = "rg-workstation-3"
      + sku_name                     = "F1"
      + worker_count                 = (known after apply)
    }

  # random_integer.ri will be created
  + resource "random_integer" "ri" {
      + id     = (known after apply)
      + max    = 99999
      + min    = 10000
      + result = (known after apply)
    }

Plan: 3 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + app_url = (known after apply)

─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.

```

This plan details which resources Terraform will create, modify, or destroy, allowing you to review before making any changes to the actual infrastructure.

### 3. Apply Your Configuration

Execute the plan to create the infrastructure:

`terraform apply`

The output should resemble the example shown below.

```
coder@workstation-3 ~/terraform-fundamentals/terraform basic commands (main *)
$ terraform apply
data.azurerm_resource_group.studentrg: Reading...
data.azurerm_resource_group.studentrg: Read complete after 0s [id=/subscriptions/769d8f7e-e398-4cbf-8014-0019e1fdee59/resourceGroups/rg-workstation-3]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # azurerm_linux_web_app.webapp will be created
  + resource "azurerm_linux_web_app" "webapp" {
      + client_affinity_enabled                        = false
      + client_certificate_enabled                     = false
      + client_certificate_mode                        = "Required"
      + custom_domain_verification_id                  = (sensitive value)
      + default_hostname                               = (known after apply)
      + enabled                                        = true
      + ftp_publish_basic_authentication_enabled       = true
      + hosting_environment_id                         = (known after apply)
      + https_only                                     = true
      + id                                             = (known after apply)
      + key_vault_reference_identity_id                = (known after apply)
      + kind                                           = (known after apply)
      + location                                       = "westeurope"
      + name                                           = (known after apply)
      + outbound_ip_address_list                       = (known after apply)
      + outbound_ip_addresses                          = (known after apply)
      + possible_outbound_ip_address_list              = (known after apply)
      + possible_outbound_ip_addresses                 = (known after apply)
      + public_network_access_enabled                  = true
      + resource_group_name                            = "rg-workstation-3"
      + service_plan_id                                = (known after apply)
      + site_credential                                = (sensitive value)
      + webdeploy_publish_basic_authentication_enabled = true
      + zip_deploy_file                                = (known after apply)

      + site_config {
          + always_on                               = false
          + container_registry_use_managed_identity = false
          + default_documents                       = (known after apply)
          + detailed_error_logging_enabled          = (known after apply)
          + ftps_state                              = "Disabled"
          + health_check_eviction_time_in_min       = (known after apply)
          + http2_enabled                           = false
          + ip_restriction_default_action           = "Allow"
          + linux_fx_version                        = (known after apply)
          + load_balancing_mode                     = "LeastRequests"
          + local_mysql_enabled                     = false
          + managed_pipeline_mode                   = "Integrated"
          + minimum_tls_version                     = "1.2"
          + remote_debugging_enabled                = false
          + remote_debugging_version                = (known after apply)
          + scm_ip_restriction_default_action       = "Allow"
          + scm_minimum_tls_version                 = "1.2"
          + scm_type                                = (known after apply)
          + scm_use_main_ip_restriction             = false
          + use_32_bit_worker                       = true
          + vnet_route_all_enabled                  = false
          + websockets_enabled                      = false
          + worker_count                            = (known after apply)

          + application_stack {
              + docker_image_name        = "eficode-academy/quotes-flask-frontend:release"
              + docker_registry_password = (sensitive value)
              + docker_registry_url      = "https://ghcr.io"
              + docker_registry_username = (known after apply)
            }
        }
    }

  # azurerm_service_plan.example will be created
  + resource "azurerm_service_plan" "example" {
      + id                           = (known after apply)
      + kind                         = (known after apply)
      + location                     = "westeurope"
      + maximum_elastic_worker_count = (known after apply)
      + name                         = "example"
      + os_type                      = "Linux"
      + per_site_scaling_enabled     = false
      + reserved                     = (known after apply)
      + resource_group_name          = "rg-workstation-3"
      + sku_name                     = "F1"
      + worker_count                 = (known after apply)
    }

  # random_integer.ri will be created
  + resource "random_integer" "ri" {
      + id     = (known after apply)
      + max    = 99999
      + min    = 10000
      + result = (known after apply)
    }

Plan: 3 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + app_url = (known after apply)

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: 

```

You will be prompted to approve the action by typing 'yes'. 

As you will see in the terminal prompt, 'yes' is the only acceptable value here, everything else will cancel the command. 

Once confirmed, Terraform will apply the specified configurations, provisioning the necessary resources for the Flask application.

The output should resemble the example shown below.

```
random_integer.ri: Creating...
random_integer.ri: Creation complete after 0s [id=91989]
azurerm_service_plan.example: Creating...
azurerm_service_plan.example: Still creating... [10s elapsed]
azurerm_service_plan.example: Creation complete after 18s [id=/subscriptions/769d8f7e-e398-4cbf-8014-0019e1fdee59/resourceGroups/rg-workstation-3/providers/Microsoft.Web/serverFarms/example]
azurerm_linux_web_app.webapp: Creating...
azurerm_linux_web_app.webapp: Still creating... [10s elapsed]
azurerm_linux_web_app.webapp: Still creating... [20s elapsed]
azurerm_linux_web_app.webapp: Still creating... [30s elapsed]
azurerm_linux_web_app.webapp: Still creating... [40s elapsed]
azurerm_linux_web_app.webapp: Still creating... [50s elapsed]
azurerm_linux_web_app.webapp: Creation complete after 59s [id=/subscriptions/769d8f7e-e398-4cbf-8014-0019e1fdee59/resourceGroups/rg-workstation-3/providers/Microsoft.Web/sites/webapp-workstation-3-91989]

Apply complete! Resources: 3 added, 0 changed, 0 destroyed.

Outputs:

app_url = "webapp-workstation-3-91989.azurewebsites.net"
```

### 4. Visit the application in the browser

You will get an app url when you applied the configurations as part of the output logs. Copy the url and paste in your browser.

You should see something like this

![image](https://github.com/eficode-academy/terraform-fundamentals/assets/71190161/77275510-e48f-4cc1-b5e9-a8ab7308f9a2)

## Remember to clean up! 💡

Execute the following command to remove all resources and clean up the infrastructure:

`terraform destroy`

This command will prompt you to review and confirm the destruction of the resources defined in your Terraform configuration. 

Once confirmed, Terraform will proceed to safely remove all the resources, effectively cleaning up the deployed infrastructure. 

This step helps prevent unnecessary costs and ensures that the environment is reset for future exercises.

The output should resemble the example shown below.

```
coder@workstation-3 ~/terraform-fundamentals/terraform-basic-commands (main *)
$ terraform destroy
random_integer.ri: Refreshing state... [id=91989]
data.azurerm_resource_group.studentrg: Reading...
data.azurerm_resource_group.studentrg: Read complete after 0s [id=/subscriptions/769d8f7e-e398-4cbf-8014-0019e1fdee59/resourceGroups/rg-workstation-3]
azurerm_service_plan.example: Refreshing state... [id=/subscriptions/769d8f7e-e398-4cbf-8014-0019e1fdee59/resourceGroups/rg-workstation-3/providers/Microsoft.Web/serverFarms/example]
azurerm_linux_web_app.webapp: Refreshing state... [id=/subscriptions/769d8f7e-e398-4cbf-8014-0019e1fdee59/resourceGroups/rg-workstation-3/providers/Microsoft.Web/sites/webapp-workstation-3-91989]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  - destroy

Terraform will perform the following actions:

  # azurerm_linux_web_app.webapp will be destroyed
  - resource "azurerm_linux_web_app" "webapp" {
      - app_settings                                   = {} -> null
      - client_affinity_enabled                        = false -> null
      - client_certificate_enabled                     = false -> null
      - client_certificate_mode                        = "Required" -> null
      - custom_domain_verification_id                  = (sensitive value) -> null
      - default_hostname                               = "webapp-workstation-3-91989.azurewebsites.net" -> null
      - enabled                                        = true -> null
      - ftp_publish_basic_authentication_enabled       = true -> null
      - https_only                                     = true -> null
      - id                                             = "/subscriptions/769d8f7e-e398-4cbf-8014-0019e1fdee59/resourceGroups/rg-workstation-3/providers/Microsoft.Web/sites/webapp-workstation-3-91989" -> null
      - key_vault_reference_identity_id                = "SystemAssigned" -> null
      - kind                                           = "app,linux,container" -> null
      - location                                       = "westeurope" -> null
      - name                                           = "webapp-workstation-3-91989" -> null
    
    }


Plan: 0 to add, 0 to change, 3 to destroy.

Changes to Outputs:
  - app_url = "webapp-workstation-3-91989.azurewebsites.net" -> null

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

azurerm_linux_web_app.webapp: Destroying... [id=/subscriptions/769d8f7e-e398-4cbf-8014-0019e1fdee59/resourceGroups/rg-workstation-3/providers/Microsoft.Web/sites/webapp-workstation-3-91989]
azurerm_linux_web_app.webapp: Still destroying... [id=/subscriptions/769d8f7e-e398-4cbf-8014-...t.Web/sites/webapp-workstation-3-91989, 10s elapsed]
azurerm_linux_web_app.webapp: Destruction complete after 10s
random_integer.ri: Destroying... [id=91989]
azurerm_service_plan.example: Destroying... [id=/subscriptions/769d8f7e-e398-4cbf-8014-0019e1fdee59/resourceGroups/rg-workstation-3/providers/Microsoft.Web/serverFarms/example]
random_integer.ri: Destruction complete after 0s
azurerm_service_plan.example: Destruction complete after 5s

Destroy complete! Resources: 3 destroyed.
```

**Congratulations!** **🎉** You have successfully deployed a web app on Azure using Terraform with basic Terraform commands.

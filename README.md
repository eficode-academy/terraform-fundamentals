# Terraform Fundamentals Training Structure

## Structure:

### Infrastructure as Code
- Introduction to IAC and Terraform
- Tool landscape (pulumi/crossplane etc)
- Intro to hahsicorp
- Terraform

### Installation
- Install/Check Terraform CLI and Azure CLI

### Launch your First VM with Terraform

Premade HCL configuration creating an app-service with an application.
This exercise should have `init`, `plan` and `apply` as well. They should not look into the code itself.

* See the URL as output of the terraform command
* Look at the website through a browser
* Use AZ cli to list the app-service as well to see that it is created (OR the UI of Azure if we can do it).
* Maybe: Apply again, to see that nothing is changing?

### Terraform Basic Commands
- `terraform init`
- `terraform plan`
- `terraform apply`
- `terraform destroy`

### Terraform Destroy
- **Lab:** Destroy the app-service created

### Basic intro to HCL language
- Overview (why create another language)
- Basic types/usages

### Providers & Resources
- Understanding Statefiles
  - Current state vs Desired
  - Remote state
  - Remote backend
- `terraform refresh`

**Lab:** Setup remote backend
* Write HCL to create the backend where they can store their state file.
* Resource block
* Add a remote backend block to store the state file.
* Optionally use AZ cli to see the state file in the state (or UI)
* If possible: make a manual change (CLI/UI) and execute `terraform refresh` to see that the state and current config has diverged.
  
**10 Break**

### Configurations
- Attributes
- Variables
  - `tfvars` file
  - Precedence
  - Data types
- Output values
- Count
- Conditional expressions

**Lab**
- Functions

**Lab**
- Dynamic blocks
- Lifecycle - Meta arguments

**Lab**
### Lab
hosting a static website
  - Cretaing azure storage with unique name
  - upload html file

### Break

### Quiz

### Terraform Modules 
- **Lab:** [Include lab details here]

### Terraform Workspaces
- **Lab:** [Include lab details here]

**Break**

### Terraform Import

### Terraform Testing Framework

### Terraform Cloud/Enterprise Features

### Best Practices
 Managing Terraform and Azure
 

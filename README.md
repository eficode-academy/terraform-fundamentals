
# Terraform Fundamentals Katas

Welcome to the Terraform Fundamentals Katas! This repository is designed to help new users master Terraform through practical exercises hosted on the Azure cloud.

Each kata focuses on essential concepts and skills, providing a hands-on approach to learning infrastructure as code with Terraform.

Whether you're starting from scratch or looking to deepen your understanding, these challenges will guide you through creating, modifying, and managing Azure resources using Terraform.

Dive in and start your journey to becoming proficient with Terraform!

## About Terraform

Terraform serves as an infrastructure as code (IaC) tool designed to automate the provisioning and management of cloud resources. Users define their desired infrastructure configuration using HashiCorp Configuration Language (HCL), allowing for the creation, modification, and scaling of resources across various cloud platforms such as AWS, Azure, and Google Cloud. Its core functionalities include:

- **Declarative Syntax**: Define the desired state of your infrastructure, and Terraform will make it happen.
- **Modular Design**: Reusable components called modules help in managing complex systems with simplicity.
- **Execution Plan**: Terraform calculates and shows the actions needed to achieve the desired state before making any changes.

Terraform enhances collaboration, ensures infrastructure consistency, and supports a version-controlled, collaborative approach to managing cloud environments.

For more detailed information, visit the [Terraform Documentation](https://developer.hashicorp.com/terraform/docs).

## Exercise List in Order

1. [00-intro.md](https://github.com/eficode-academy/terraform-fundamentals/blob/main/00-intro.md)
2. [01-terraform-basic-commands.md](https://github.com/eficode-academy/terraform-fundamentals/blob/main/01-terraform-basic-commands.md)
3. [02-Create-and-Manage-Resources-with-Terraform.md](https://github.com/eficode-academy/terraform-fundamentals/blob/main/02-Create-and-Manage-Resources-with-Terraform.md)
4. [03-Implementing-Remote-State-Management.md](https://github.com/eficode-academy/terraform-fundamentals/blob/main/03-Implementing-Remote-State-Management.md)
5. [04-Using-Terraform-Functions-and-Other-Commands.md](https://github.com/eficode-academy/terraform-fundamentals/blob/main/04-Using-Terraform-Functions-and-Other-Commands.md)
6. [05-Setup-VM-Using-Terraform.md](https://github.com/eficode-academy/terraform-fundamentals/blob/main/05-Setup-VM-Using-Terraform.md)
7. [06-Applying-Modules-in-Terraform.md](https://github.com/eficode-academy/terraform-fundamentals/blob/main/06-Applying-Modules-in-Terraform.md)

## Using this outside of the workshop

- Terraform CLI and Azure CLI installed on your machine.
- Access to a cloud provider account with permissions to create and manage resources.
- Basic knowledge of command line interfaces and text editors.

## Repository Structure

```
.
├── 00-intro.md
├── 01-terraform-basic-commands.md
├── 02-Create-and-Manage-Resources-with-Terraform.md
├── 03-Implementing-Remote-State-Management.md
├── 04-Using-Terraform-Functions-and-Other-Commands.md
├── 05-Setup-VM-Using-Terraform.md
├── 06-Applying-Modules-in-Terraform.md
├── LICENSE
├── README.md
├── app
├── labs
├── modules_internals
├── trainer
└── bestpractices.md
```

## Links

- [Terraform Documentation](https://developer.hashicorp.com/terraform/docs)
- [Azure Documentation](https://docs.microsoft.com/en-us/azure/)
- [Best Practices](https://github.com/eficode-academy/terraform-fundamentals/blob/main/bestpractices.md)

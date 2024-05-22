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

## Pre-requisites
- Terraform CLI and Azure CLI installed on your machine
- Access to a cloud provider account with permissions to create and manage resources
- Basic knowledge of command line interfaces and text editors

# Terraform Course Outline

## Module 1: Introduction to Infrastructure as Code (IaC)

### Objective
Understand the concept and benefits of Infrastructure as Code (IaC).

### Topics Covered
- What is IaC?
- Benefits of using IaC
- Overview of IaC tools with a focus on Terraform

## Module 2: Terraform Basics

### Objective
Learn the fundamental concepts of Terraform.

### Topics Covered
- Why Terraform?
- Installing and setting up Terraform
- Terraform workflow
- Terraform language
- Authenticating via Azure CLI / Intro to Azure Portal (UI)

### Lab Exercise: labs/01-terraform-basic-commands

- Basic commands: `init`, `plan`, `apply`, `destroy`
- Other Terraform Commands:
  - `validate`
  - `fmt`
  - `version`


## Module 3: Terraform Core Concepts

### Objective
Deep dive into Terraform’s core components.

### Topics Covered
- Providers
- Resources
- Data sources
- Variables
  - Input Vars 
- Outputs
- Terraform commands
  - `output`
  - `providers`
  - `show`
  - `get`
  - `import`

### Lab Exercise: Create and Manage Resources with Terraform

## Module 4: Terraform State Management

### Objective
Understand how Terraform manages state.

### Topics Covered
- What is Terraform state
- Remote state management
- Inspecting and modifying state

### Lab Exercise: Implementing Remote State Management

## Module 5: Terraform Functions and Advanced Commands

### Objective
Understand how to utilize built-in functions and master other Terraform commands.

### Topics Covered

- Local Block
- Expressions
  - Conditional expressions
  - For expressions
  - Dynamic Block
- Meta-Arguments
  - count
  - for_each
  - depends_on
  - lifecycle
- Introduction to Functions
  - Types of Built-in Functions
 
- Terraform commands
  - `console`
  - `graph`

### Lab Exercise: Using Terraform Functions and Advanced Commands

### Lab Exercise: Setup Vm using using terrafrom

## Module 6: Advanced Configuration

### Objective
Master advanced Terraform configurations.

### Topics Covered

- Terraform modules
- Terraform workspaces

### Lab Exercise: Applying Modules and workspaces in Terrafrom

## Module 7: Overview of Terraform Cloud/ Enterprise

- Terraform Cloud / Enterprise

## Module 8: Best Practices

### Objective
Learn to secure Terraform configurations and follow best practices.

### Topics Covered
- Best Practices.md

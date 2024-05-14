# Terraform Fundamentals Katas

Welcome to the Terraform Fundamentals Katas! This repository is designed to help new users master Terraform through practical exercises hosted on the Azure cloud. Each kata focuses on essential concepts and skills, providing a hands-on approach to learning infrastructure as code with Terraform.

Whether you're starting from scratch or looking to deepen your understanding, these challenges will guide you through creating, modifying, and managing Azure resources effectively. Dive in and start your journey to becoming proficient with Terraform!

## About Terraform

Terraform serves as an infrastructure as code (IaC) tool designed to automate the provisioning and management of cloud resources. Users define their desired infrastructure configuration using HashiCorp Configuration Language (HCL), allowing for the creation, modification, and scaling of resources across various cloud platforms such as AWS, Azure, and Google Cloud. Its core functionalities include:

- **Declarative Syntax**: Define the desired state of your infrastructure, and Terraform will make it happen.
- **Modular Design**: Reusable components called modules help in managing complex systems with simplicity.
- **Execution Plan**: Terraform calculates and shows the actions needed to achieve the desired state before making any changes.

Terraform enhances collaboration, ensures infrastructure consistency, and supports a version-controlled, collaborative approach to managing cloud environments.

# Terraform Course Outline

## Module 1: Introduction to Infrastructure as Code (IaC)

### Objective
Understand the concept and benefits of Infrastructure as Code (IaC).

### Topics Covered
- What is IaC?
- Benefits of using IaC.
- Overview of IaC tools with a focus on Terraform.

## Module 2: Terraform Basics

### Objective
Learn the fundamental concepts of Terraform.

### Topics Covered
- What is Terraform?
- Installing and setting up Terraform.
- Login to Azure CLI
- Basic commands: `init`, `plan`, `apply`, `destroy`.

### Lab Exercise: Terraform basic commands

## Module 3: Terraform Core Concepts

### Objective
Deep dive into Terraform’s core components.

### Topics Covered
- Providers
  - Terraform providers
- Resources
- Data sources
- Outputs
- Variables

### Lab Exercise: Create and Manage Resources with Terraform

## Module 4: Terraform State Management

### Objective
Understand how Terraform manages state.

### Topics Covered
- Purpose of Terraform state
- Remote state management
- Locking state
- Inspecting and modifying state:
  - Terraform state
  - Terraform refresh

### Lab Exercise: Implementing Remote State Management

## Module 5: Terraform Functions and Advanced Commands

### Objective
Understand how to utilize built-in functions and master other Terraform commands.

### Topics Covered
- Introduction to Functions
- Types of Built-in Functions
- Other Terraform Commands:
  - `validate`
  - `fmt`
  - `output`
  - `providers`
  - `show`
  - `version`
  - `get`
  - `console`
  - `graph`
  - `test`
  - `import`
- Terrafrom Provisioners 
  -Local-exec
  -Remote-exec
- Local Block 
- Conditional expressions
- For expressions
- Meta-Arguments:
  - `depends_on`
  - `count`
  - `for_each`
  - `lifecycle`

### Lab Exercise: Using Terraform Functions and Advanced Commands

### Lab Exercise: Deploy a Multi-Tier Application using terrafrom

## Module 6: Advanced Configuration

### Objective
Master advanced Terraform configurations.

### Topics Covered

-  Dynamic blocks
- Terraform modules
- Terraform Workspaces

### Lab Exercise: Applying Modules and workspaces in Terrafrom

## Module 7: Terraform Cloud and Enterprise

### Objective
Utilize Terraform in a team setting with Terraform Cloud.

### Topics Covered
- Benefits of Using Terraform Cloud

## Module 8: Best Practices and Security

### Objective
Learn to secure Terraform configurations and follow best practices.

### Topics Covered
- (Topics related to best practices and security measures in Terraform)
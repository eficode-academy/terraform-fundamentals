# Terraform Basics: Deploying a Flask Application

## Learning Goals
- Execute the basic Terraform commands: `terraform init`, `terraform plan`, and `terraform apply`, and observe how they function in managing infrastructure.

## Introduction
This exercise provides an introduction to the basics commands of Terraform through the setup and deployment of a Flask application. Students will get to directly apply the basic Terraform commands, observe the changes each command makes, and understand their roles in the workflow of infrastructure as code.

## Pre-requisites
- Terraform installed on your local machine.
- Access to a cloud provider account with permissions to create and manage resources.
- Basic knowledge of command line interfaces and text editors.

## Project Structure
Ensure your project is structured as follows to facilitate the steps in this guide:

**will be updated**

/project-root 

/app
- app.py # Simple Flask web server application
- requirements.txt # Python dependencies required for the Flask app
/terraform
- main.tf # Main Terraform configuration file
- variables.tf # Variable definitions for Terraform
- outputs.tf # Output configurations for Terraform



### Flask Application
The `app` directory contains a basic Flask application, Our small example flask application that displays quotes.

The application consists of three components, frontend, backend and a database.

The frontend and backend are small python flask webservers that listen for HTTP requests. 

### Terraform Configuration
The Terraform configuration in the `terraform` directory is set to define and provision the necessary cloud infrastructure to run the Flask application, which typically includes server setup, networking, and security settings.

## Step-by-Step Instructions

### 1. Initialize Your Terraform Workspace
Navigate to the `terraform` directory within your project

Initialize the Terraform workspace to prepare your environment:

`terraform init`


The output should resemble the example shown below.

```
```

This command sets up Terraform, installing any required provider plugins and setting up the backend for state management.

### 2. Plan Your Deployment

Generate an execution plan to preview the actions Terraform will take based on the configurations

`terraform plan`

The output should resemble the example shown below.

```
```

This plan details which resources Terraform will create, modify, or destroy, allowing you to review before making any changes to the actual infrastructure.

### 3. Apply Your Configuration

Execute the plan to create the infrastructure:


`terraform apply`


The output should resemble the example shown below.

```
```

You will be prompted to approve the action. Once confirmed, Terraform will apply the specified configurations, provisioning the necessary resources for the Flask application.


### 4. Visit the application in the browser.

You should see something like this:
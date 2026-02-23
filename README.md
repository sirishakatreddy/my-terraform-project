# Terraform VPC and EC2 Project

This repository contains a Terraform project that provisions AWS infrastructure using Infrastructure as Code (IaC).

The main objective of this project is to create a custom VPC and an EC2 instance in AWS.

---

## Repository Structure

my-terraform-project/
└── project-vpc-ec2/
    ├── main.tf
    ├── backend.tf
    ├── provider.tf
    ├── variables.tf
    └── outputs.tf

---

## AWS Resources Created

This Terraform project creates the following AWS resources:

- VPC
- Public Subnet
- Internet Gateway
- Route Table and Route Table Association
- Security Group
- EC2 Instance
- S3 Backend for Terraform state (if configured)

---

## File Description

main.tf  
Contains the main Terraform configuration for VPC, subnet, EC2, and networking resources.

provider.tf  
Defines the AWS provider and region.

backend.tf  
Configures remote backend using S3 for Terraform state storage.

variables.tf  
Defines input variables used in the project.

outputs.tf  
Displays output values such as VPC ID and EC2 details.

---

## How to Use This Project

1. Clone the repository
2. Navigate to the project directory:
   project-vpc-ec2
3. Initialize Terraform:
   terraform init
4. Review the plan:
   terraform plan
5. Apply the configuration:
   terraform apply

---

## Prerequisites

- AWS Account
- AWS CLI configured
- Terraform installed

---

## Purpose

This project is created for learning Terraform and AWS services such as VPC and EC2, and for academic / interview preparation.

---

## Author

Sirisha Katreddy

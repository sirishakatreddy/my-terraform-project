variable "region" {
  description = "VPC region"
  type        = string
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "subnet_cidr_1" {
  description = "Subnet CIDR 1"
  type        = string
}

variable "subnet_cidr_2" {
  description = "Subnet CIDR 2"
  type        = string
}

variable "instance_ami" {
  description = "EC2 instance ami"
  type = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "state_bucket_name" {
  description = "S3 bucket for Terraform state"
  type        = string
}

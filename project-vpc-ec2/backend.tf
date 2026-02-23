terraform {
  backend "s3" {
    bucket         = "siri-tf-pvt-bucket"
    key            = "VPC_2webservers/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}

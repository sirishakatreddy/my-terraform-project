terraform {
  backend "s3" {
    bucket         = "siri-tf-pvt-bkt"
    key            = "VPC_2webservers/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "siri-tf-dynamodb-table"
  }
}

provider "aws" {
  region = "us-east-1"
}

terraform {
  required_version = ">= 0.12.0"
}

data "aws_vpc" "existing" {
  id = ""  # replace with your existing VPC ID
  # Alternatively, a filter can find the VPC by name or other attributes
}

data "aws_subnets" "all" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.existing.id]
  }
}
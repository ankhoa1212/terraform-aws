# #Used to establish connection between VS code terrafrom and Aws account
# terraform {
#     required_version = "~> 1.0"
#         required_providers {
#             aws = {
#                 source  = "hashicorp/aws"
#                 version = "~> 5.1.0"
#             }
#         }
# }
# provider "aws" {
#     region = "us-east-1" #Change this to your preferred region
#     assume_role {
#             role_arn = "hello-world-role-m3ospoy0" #This is the deploy role in the account you are using to deploy the resources
#     }
# }
provider "aws" {
    region = "us-east-1"
}
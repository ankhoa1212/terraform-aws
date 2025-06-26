variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}
variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
}
variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
}
variable "db_subnet_cidrs" {
  description = "List of CIDR blocks for database subnets"
  type        = list(string)
}
variable "azs" {
  description = "List of availability zones"
  type        = list(string)
}
variable "access_ip" {
  description = "IP address or CIDR block for access control"
  type        = string
}
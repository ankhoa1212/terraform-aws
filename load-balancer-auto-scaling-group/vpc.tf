# VPC
resource "aws_vpc" "austin_vpc" {
  cidr_block = "10.0.0.0/23" # 512 IPs 
  tags = {
    Name = "austin-vpc"
  }
}

# Creating 1st public subnet 
resource "aws_subnet" "austin_subnet_1" {
  vpc_id                  = aws_vpc.austin_vpc.id
  cidr_block              = "10.0.0.0/27" #32 IPs
  map_public_ip_on_launch = true          # public subnet
  availability_zone       = "us-east-1a"
}
# Creating 2nd public subnet 
resource "aws_subnet" "austin_subnet_1a" {
  vpc_id                  = aws_vpc.austin_vpc.id
  cidr_block              = "10.0.0.32/27" #32 IPs
  map_public_ip_on_launch = true           # public subnet
  availability_zone       = "us-east-1b"
}
# Creating 1st private subnet
resource "aws_subnet" "austin_subnet_2" {
  vpc_id                  = aws_vpc.austin_vpc.id
  cidr_block              = "10.0.1.0/27" #32 IPs
  map_public_ip_on_launch = false         # private subnet
  availability_zone       = "us-east-1b"
}
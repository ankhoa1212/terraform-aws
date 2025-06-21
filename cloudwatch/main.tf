# -----------------------------------------------------------------------------
# Provider Configuration
# -----------------------------------------------------------------------------
# Specifies the AWS provider and the region where the resources will be created.
# -----------------------------------------------------------------------------
provider "aws" {
  region = "us-east-1"
}

# -----------------------------------------------------------------------------
# Data Source for Amazon Linux 2 AMI
# -----------------------------------------------------------------------------
# Fetches the latest Amazon Linux 2 AMI ID. This avoids hardcoding an AMI ID,
# which can become outdated.
# -----------------------------------------------------------------------------
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


# -----------------------------------------------------------------------------
# VPC (Virtual Private Cloud) Resources
# -----------------------------------------------------------------------------

# 1. Create the Virtual Private Cloud (VPC)
resource "aws_vpc" "lab_vpc" {
  cidr_block           = "10.0.0.0/24"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "LabVPC"
  }
}

# 2. Create the Public Subnet
resource "aws_subnet" "lab_subnet" {
  vpc_id            = aws_vpc.lab_vpc.id
  cidr_block        = "10.0.0.0/26"
  availability_zone = "us-east-1a"

  # Enable auto-assignment of public IPs for instances launched in this subnet.
  map_public_ip_on_launch = true

  tags = {
    Name = "LabSubnet"
  }
}

# 3. Create the Internet Gateway (IGW)
resource "aws_internet_gateway" "lab_igw" {
  vpc_id = aws_vpc.lab_vpc.id

  tags = {
    Name = "LabIGW"
  }
}

# 4. Create a Route in the Main Route Table
# This route directs all outbound traffic (0.0.0.0/0) to the Internet Gateway.
resource "aws_route" "default_route" {
  route_table_id         = aws_vpc.lab_vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.lab_igw.id
}

# 4.1 Associate the Route Table with the Public Subnet
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.lab_subnet.id
  route_table_id = aws_vpc.lab_vpc.main_route_table_id
}


# -----------------------------------------------------------------------------
# CloudWatch and VPC Flow Log Resources
# -----------------------------------------------------------------------------

# 5. Create a CloudWatch Log Group for VPC Flow Logs
resource "aws_cloudwatch_log_group" "lab_log_group" {
  name              = "/aws/lambda/Lab-Log-Group"
  retention_in_days = 0 # 0 means "Never expire"
}

# 6. Create the IAM Role and Policy for VPC Flow Logs
# This role grants VPC Flow Logs the permissions needed to publish logs to CloudWatch.

# IAM Policy Document
data "aws_iam_policy_document" "flow_logs_policy_doc" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams"
    ]
    resources = ["*"] # As per the request, though can be scoped down for production.
  }
}

# IAM Role
resource "aws_iam_role" "flow_logs_role" {
  name               = "vpc-flow-logs-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# Attach the policy to the role
resource "aws_iam_role_policy" "flow_logs_policy_attach" {
  name   = "flow-logs-policy"
  role   = aws_iam_role.flow_logs_role.id
  policy = data.aws_iam_policy_document.flow_logs_policy_doc.json
}


# 7. Create the VPC Flow Log
resource "aws_flow_log" "my_flowlog_cloudwatch" {
  log_destination      = aws_cloudwatch_log_group.lab_log_group.arn
  log_destination_type = "cloud-watch-logs"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.lab_vpc.id
  iam_role_arn         = aws_iam_role.flow_logs_role.arn
  max_aggregation_interval = 60 # 60 seconds = 1 minute

  tags = {
    Name = "my-flowlog-cloudwatch"
  }

  # Ensure the IAM role is created before the flow log
  depends_on = [aws_iam_role_policy.flow_logs_policy_attach]
}


# -----------------------------------------------------------------------------
# EC2 Instance Resources
# -----------------------------------------------------------------------------

# 8. Create a Security Group for the EC2 Instance
resource "aws_security_group" "lab_sg" {
  name        = "LabSG"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.lab_vpc.id

  # Inbound rule to allow SSH from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Egress rule to allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # "-1" means all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "LabSG"
  }
}

# 9. Launch the EC2 Instance
resource "aws_instance" "lab_instance" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.lab_subnet.id

  # Associate the security group created above
  vpc_security_group_ids = [aws_security_group.lab_sg.id]

  # As per request, public IP is enabled on the subnet level,
  # but we can be explicit here as well.
  associate_public_ip_address = true

  # No key_name argument is provided, to "Proceed without a key pair"

  tags = {
    Name = "LabInstance"
  }
}

# -----------------------------------------------------------------------------
# Outputs
# -----------------------------------------------------------------------------
# These outputs display important information after the infrastructure is created.
# -----------------------------------------------------------------------------
output "vpc_id" {
  description = "The ID of the created VPC."
  value       = aws_vpc.lab_vpc.id
}

output "instance_id" {
  description = "The ID of the EC2 instance."
  value       = aws_instance.lab_instance.id
}

output "instance_public_ip" {
  description = "The public IP address of the EC2 instance."
  value       = aws_instance.lab_instance.public_ip
}

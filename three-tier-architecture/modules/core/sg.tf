# Security Groups for the VPC
resource "aws_security_group" "web_alb" {
  name        = "web-alb-sg"
  description = "Allow HTTP inbound traffic to Web ALB"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTP from anywhere
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allow all outbound
  }

  tags = {
    Name = "web-alb-sg"
  }
}

resource "aws_security_group" "web_instance" {
  name        = "web-instance-sg"
  description = "Allow HTTP from Web ALB, all outbound"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.web_alb.id] # Only allow traffic from the Web ALB
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allow all outbound
  }

  tags = {
    Name = "web-instance-sg"
  }
}

resource "aws_security_group" "app_alb" {
  name        = "app-alb-sg"
  description = "Allow HTTP/App traffic from Web instances"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 8080 # Assuming app runs on 8080, adjust as needed
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.web_instance.id] # Only allow traffic from Web instances
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allow all outbound
  }

  tags = {
    Name = "app-alb-sg"
  }
}

# App Instance Security Group
resource "aws_security_group" "app_instance" {
  name        = "app-instance-sg"
  description = "Allow App traffic from App ALB and all outbound"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 8080 # Assuming app runs on 8080, adjust as needed
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.app_alb.id] # Only allow traffic from the App ALB
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id] # Allow SSH from Bastion host
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allow all outbound
  }

  tags = {
    Name = "app-instance-sg"
  }
}

# Database Security Group
resource "aws_security_group" "database" {
  name        = "db-sg"
  description = "Allow MySQL access from app tier"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app_instance.id] # Only allow traffic from App instances
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allow all outbound
  }

  tags = {
    Name = "db-sg"
  }
}

resource "aws_security_group" "bastion" {
  name        = "bastion_sg"
  description = "Allow SSH Inbound Traffic From Set IP"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.access_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
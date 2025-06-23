output "vpc_id" {
  description = "The ID of the created VPC."
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "List of IDs of the public subnets."
  value       = [for s in aws_subnet.public : s.id]
}

output "private_subnet_ids" {
  description = "List of IDs of the private subnets (App Tier)."
  value       = [for s in aws_subnet.private : s.id]
}

output "db_subnet_ids" {
  description = "List of IDs of the database subnets."
  value       = [for s in aws_subnet.database : s.id]
}

output "web_alb_sg_id" {
  description = "ID of the Security Group for the Web ALB."
  value       = aws_security_group.web_alb.id
}

output "web_instance_sg_id" {
  description = "ID of the Security Group for Web instances."
  value       = aws_security_group.web_instance.id
}

output "app_alb_sg_id" {
  description = "ID of the Security Group for the App ALB."
  value       = aws_security_group.app_alb.id
}

output "app_instance_sg_id" {
  description = "ID of the Security Group for App instances."
  value       = aws_security_group.app_instance.id
}

output "db_sg_id" {
  description = "ID of the Security Group for the Database."
  value       = aws_security_group.database.id
}

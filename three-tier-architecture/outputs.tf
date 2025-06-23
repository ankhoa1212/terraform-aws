# outputs.tf (Root Module)

output "web_alb_dns_name" {
  description = "The DNS name of the Web Application Load Balancer."
  value       = module.web.web_alb_dns_name
}

output "app_alb_dns_name" {
  description = "The DNS name of the Application Load Balancer."
  value       = module.app.app_alb_dns_name
}

output "rds_endpoint" {
  description = "The endpoint of the RDS database."
  value       = module.database.db_endpoint
}
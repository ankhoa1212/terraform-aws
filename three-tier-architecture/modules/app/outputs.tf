output "app_alb_dns_name" {
  description = "The DNS name of the Application Load Balancer."
  value       = aws_lb.app.dns_name
}
output "app_asg" {
  description = "The Auto Scaling Group for the App instances."
  value       = aws_autoscaling_group.app
}
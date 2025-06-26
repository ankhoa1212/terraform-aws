output "web_alb_dns_name" {
  description = "The DNS name of the Web Application Load Balancer."
  value       = aws_lb.web.dns_name
}
output "web_asg" {
  description = "The Auto Scaling Group for the Web instances."
  value       = aws_autoscaling_group.web
}
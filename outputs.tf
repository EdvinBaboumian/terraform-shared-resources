output "alb_dns_name" {
  description = "Public URL of the Application Load Balancer to access WordPress"
  value       = aws_lb.web.dns_name
}

output "rds_endpoint" {
  description = "Database Endpoint"
  value       = aws_db_instance.wordpress.endpoint
}
output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.My_VPC.id
}

output "alb_dns_name" {
  description = "Application Load Balancer DNS name"
  value       = aws_lb.My_ALB.dns_name
}

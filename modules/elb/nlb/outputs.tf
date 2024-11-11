output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = aws_lb.nlb.dns_name
}

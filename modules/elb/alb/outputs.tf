output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = aws_lb.app_lb.dns_name
}
output "target_group_arn" {
  value = aws_lb_target_group.alb_target_group.arn
}

# modules/alb/outputs.tf

output "lb_dns_name" {
  description = "The DNS name of the load balancer"
  value       = aws_lb.app_lb.dns_name
}

output "lb_zone_id" {
  description = "The zone ID of the load balancer"
  value       = aws_lb.app_lb.zone_id
}

output "lb_target_group_arn" {
  description = "The ARN of the load balancer target group"
  value       = aws_lb_target_group.app_lb_target_group.arn
}
output "app_security_group_id" {
  description = "The ID of the application security group"
  value       = aws_security_group.app_sg.id
}
output "db_security_group_id" {
  description = "The ID of the database security group"
  value       = aws_security_group.db_sg.id
}
output "lb_security_group_id" {
  description = "The ID of the load balancer security group"
  value       = aws_security_group.lb_sg.id
}
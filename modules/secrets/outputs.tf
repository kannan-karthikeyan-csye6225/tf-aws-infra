output "db_password_secret_arn" {
  description = "The ARN of the database password secret"
  value       = aws_secretsmanager_secret.db_password.arn
}

output "email_credentials_secret_arn" {
  description = "The ARN of the email credentials secret"
  value       = aws_secretsmanager_secret.email_credentials.arn
}

output "db_password_secret_id" {
  description = "The ID of the database password secret"
  value       = aws_secretsmanager_secret.db_password.id
}

output "email_credentials_secret_id" {
  description = "The ID of the email credentials secret"
  value       = aws_secretsmanager_secret.email_credentials.id
}
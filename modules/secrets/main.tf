resource "aws_secretsmanager_secret" "db_password" {
  name        = "kannan"
  kms_key_id  = var.kms_secrets_key_id

  tags = {
    Environment = var.environment
    Purpose     = "Database Password"
  }
}

resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = var.db_password
}

resource "aws_secretsmanager_secret" "email_credentials" {
  name                    = "kanz"
  kms_key_id              = var.kms_secrets_key_id
  recovery_window_in_days = 7

  tags = {
    Environment = var.environment
    Purpose     = "SendGrid API Key"
  }
}

resource "aws_secretsmanager_secret_version" "email_credentials" {
  secret_id     = aws_secretsmanager_secret.email_credentials.id
  secret_string = var.sendgrid_api_key
}

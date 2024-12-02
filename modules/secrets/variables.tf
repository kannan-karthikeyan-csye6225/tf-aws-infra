variable "kms_secrets_key_id" {
  description = "The KMS key ID used to encrypt the secrets"
  type        = string
}

variable "db_password" {
  description = "Database password to be stored in Secrets Manager"
  type        = string
  sensitive   = true
}

variable "sendgrid_api_key" {
  description = "SendGrid API key to be stored in Secrets Manager"
  type        = string
  sensitive   = true
}

variable "environment" {
  description = "The environment where secrets are being managed"
  type        = string
  default     = "demo"
}

variable "secret_recovery_window_days" {
  description = "Number of days that AWS Secrets Manager waits before deleting a secret"
  type        = number
  default     = 0  # Allows immediate deletion for testing
}
variable "lambda_zip_path" {
  description = "Path to the Lambda function ZIP file"
  type        = string
}

variable "sendgrid_api_key" {
  description = "SendGrid API Key"
  type        = string
  sensitive   = true
}

variable "sns_topic_arn" {
  description = "ARN of the SNS topic"
  type        = string
}
variable "email_credentials_arn" {
  description = "ARN of the email credentials secret"
  type        = string
}

variable "kms_key_arn" {
  description = "ARN of the KMS key used to encrypt the secret"
  type        = list(string)
}
output "ec2_key_id" {
  description = "The ID of the KMS key for EC2 encryption"
  value       = aws_kms_key.ec2_key.id
}

output "rds_key_id" {
  description = "The ID of the KMS key for RDS encryption"
  value       = aws_kms_key.rds_key.id
}

output "s3_key_id" {
  description = "The ID of the KMS key for S3 encryption"
  value       = aws_kms_key.s3_key.id
}

output "secrets_key_id" {
  description = "The ID of the KMS key for Secrets Manager"
  value       = aws_kms_key.secrets_key.id
}

output "ec2_key_arn" {
  description = "The ARN of the KMS key for EC2 encryption"
  value       = aws_kms_key.ec2_key.arn
}

output "secrets_key_arn" {
  description = "The ARN of the KMS key for Secrets Manager"
  value       = aws_kms_key.secrets_key.arn
}

output "rds_key_arn" {
  description = "The ARN of the KMS key for RDS"
  value       = aws_kms_key.rds_key.arn
}

output "s3_key_arn" {
  description = "The ARN of the KMS key for S3 encryption"
  value       = aws_kms_key.s3_key.arn
}
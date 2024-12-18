# modules/rds/variables.tf
variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "db_security_group_id" {
  description = "The ID of the database security group"
  type        = string
}

variable "db_password" {
  description = "Password for RDS instance"
  type        = string
  sensitive   = true
}

variable "rds_kms_key_id" {
  description = "The ARN of the KMS key for RDS encryption"
  type = string

}
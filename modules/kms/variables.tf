variable "aws_region" {
  description = "The AWS region where KMS keys will be created"
  type        = string
  default     = "us-west-2"
}

variable "environment" {
  description = "The environment (dev, demo, prod) for tagging purposes"
  type        = string
  default     = "demo"
}

variable "key_rotation_enabled" {
  description = "Enable automatic key rotation"
  type        = bool
  default     = true
}

variable "deletion_window_days" {
  description = "Duration in days after which the key is deleted after destruction of the resource"
  type        = number
  default     = 10
}

variable "key_description_prefix" {
  description = "Prefix for KMS key descriptions"
  type        = string
  default     = "CSYE6225 Encryption Key"
}
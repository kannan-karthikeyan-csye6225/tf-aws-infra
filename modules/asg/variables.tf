# modules/asg/variables.tf
variable "custom_ami" {
  description = "AMI for the EC2 instance"
  type        = string
}

variable "key_name" {
  description = "The name of the key pair to use for the EC2 instances"
  type        = string
}

variable "app_security_group_id" {
  description = "The ID of the application security group"
  type        = string
}

variable "user_data" {
  description = "The user data script to run on the EC2 instances"
  type        = string
}

variable "lb_target_group_arn" {
  description = "The ARN of the load balancer target group"
  type        = string
}

variable "public_subnet_ids" {
  description = "The IDs of the public subnets"
  type        = list(string)
}
variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}
variable "bucket_arn" {
  description = "The ARN of the example S3 bucket"
  type        = string
}

variable "sns_topic_arn" {
  description = "ARN of the SNS topic"
  type        = string
}

variable "aws_profile" {
  description = "AWS CLI profile to use"
  type        = string
}
variable "db_password_arn" {
  description = "ARN of the database password secret"
  type        = string
}

variable "email_credentials_arn" {
  description = "ARN of the email credentials secret"
  type        = string
}

variable "kms_key_arns" {
  description = "List of KMS key ARNs that the EC2 instances can decrypt"
  type        = list(string)
}

variable "s3_kms_key_arn" {
  description = "The ARN of the KMS key for S3 encryption"
  type        = string
}
variable "custom_ami" {
  description = "AMI for the EC2 instance"
  type        = string
}

variable "public_subnet_id" {
  description = "The ID of the public subnet for the EC2 instance"
  type        = string
}

variable "app_security_group_id" {
  description = "The ID of the application security group"
  type        = string
}

variable "db_password" {
  description = "Password for RDS instance"
  type        = string
  sensitive   = true
}

variable "db_endpoint" {
  description = "The endpoint of the RDS instance"
  type        = string
}
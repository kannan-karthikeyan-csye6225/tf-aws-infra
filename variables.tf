# variables.tf
variable "aws_region" {
  description = "The AWS region to deploy to"
  type        = string
}

variable "aws_profile" {
  description = "AWS CLI profile to use"
  type        = string
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "List of availability zones to distribute subnets"
  type        = list(string)
}

variable "app_port" {
  description = "Port on which the application runs"
  type        = number
}

variable "custom_ami" {
  description = "AMI for the EC2 instance"
  type        = string
}

variable "db_password" {
  description = "Password for RDS instance"
  type        = string
  sensitive   = true
}

variable "subdomain_name" {
  description = "The subdomain for DNS record"
  type        = string
}

variable "key_name" {
  description = "The name of the key pair to use for the EC2 instances"
  type        = string
}

variable "sendgrid_api_key" {
  description = "SendGrid API key"
  type        = string
  sensitive   = true
}
variable "lambda_zip_path" {
  description = "Path to the Lambda function ZIP file"
  type        = string
}
variable "domain_name" {
  description = "Base domain name"
  type        = string
  default     = "leodas.me"
}
variable "ssl_certificate_arn" {
  description = "ARN of the SSL certificate for the load balancer"
  type        = string
}
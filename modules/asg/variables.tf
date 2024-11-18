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
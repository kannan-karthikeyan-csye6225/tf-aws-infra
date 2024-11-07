variable "lb_security_group_id" {
  description = "The ID of the security group for the load balancer"
  type        = string
}

variable "public_subnet_ids" {
  description = "The IDs of the public subnets"
  type        = list(string)
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "app_port" {
  description = "Port on which the application runs"
  type        = number
}
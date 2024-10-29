variable "subdomain_name" {
  description = "The subdomain for which to create the DNS A record"
  type        = string
}

variable "instance_public_ip" {
  description = "The public IP of the EC2 instance"
  type        = string
}
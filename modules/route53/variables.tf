# modules/route53/variables.tf
variable "subdomain_name" {
  description = "The subdomain for which to create the DNS A record"
  type        = string
}

variable "lb_dns_name" {
  description = "The DNS name of the load balancer"
  type        = string
}

variable "lb_zone_id" {
  description = "The zone ID of the load balancer"
  type        = string
}
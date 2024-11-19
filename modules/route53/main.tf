# modules/route53/main.tf

data "aws_route53_zone" "selected" {
  name         = "${var.subdomain_name}.leodas.me."
  private_zone = false
}

resource "aws_route53_record" "app_dns_record" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "${var.subdomain_name}.leodas.me"  # Use the full subdomain name
  type    = "A"

  alias {
    name                   = var.lb_dns_name  # Points to ALB's DNS name
    zone_id                = var.lb_zone_id  # ALB's zone ID
    evaluate_target_health = true
  }
}
data "aws_route53_zone" "selected" {
  name         = "${var.subdomain_name}.leodas.me."
  private_zone = false
}

resource "aws_route53_record" "dev_a_record" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = data.aws_route53_zone.selected.name
  type    = "A"
  ttl     = "300"
  records = [var.instance_public_ip]
}
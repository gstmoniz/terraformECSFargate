data "aws_route53_zone" "main-zone" {
  name = "${var.dns_name}"
}

resource "aws_route53_record" "alb-record" {
  zone_id = data.aws_route53_zone.main-zone.zone_id
  name = "alb.${var.dns_name}"
  type = "A"
  
  alias {
    name = aws_alb.ecs-alb.dns_name
    zone_id = aws_alb.ecs-alb.zone_id
    evaluate_target_health = true
  }
}
resource "aws_alb" "ecs-alb" {
  name = "ecs-sphfs-alb"
  load_balancer_type = "application"
  security_groups = [ aws_security_group.alb-sc.id ]
  subnets = module.vpc.public_subnets
}

data "aws_acm_certificate" "certificate" {
  domain      = "alb.${var.dns_name}"
  statuses    = ["ISSUED"]
  most_recent = true
}

resource "aws_alb_listener" "ecs-alb-listener" {
  depends_on = [
    aws_route53_record.alb-record
  ]
  load_balancer_arn = aws_alb.ecs-alb.arn
  port = "443"
  protocol = "HTTPS"
  ssl_policy = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn = data.aws_acm_certificate.certificate.arn

  default_action {
    type = "fixed-response"
    
    fixed_response {
      content_type = "text/plain"
      message_body = "access denied"
      status_code  = "403"
    }
  }
}

resource "aws_lb_listener_rule" "http-header" {
  listener_arn = aws_alb_listener.ecs-alb-listener.arn

  action {
    type = "forward"
    target_group_arn = aws_alb_target_group.ecs-alb-target.arn
  }

  condition {
    http_header {
      http_header_name = "access"
      values = ["123456"]
    }
  }
}

resource "aws_alb_listener" "redirect" {
  load_balancer_arn = aws_alb.ecs-alb.arn
  port = "80"
  protocol = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port = "443"
      protocol = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_alb_target_group" "ecs-alb-target" {
  name = "ecs-sphfs-target"
  port = "8080"
  protocol = "HTTP"
  target_type = "ip"
  vpc_id = module.vpc.vpc_id
}

output "sphfs-dns" {
  value = aws_alb.ecs-alb.dns_name
}
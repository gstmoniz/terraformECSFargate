resource "aws_alb" "ecs-alb" {
  name = "ecs-sphfs-alb"
  load_balancer_type = "application"
  security_groups = [ aws_security_group.alb-sc.id ]
  subnets = module.vpc.public_subnets
}

resource "aws_alb_listener" "ecs-alb-listener" {
  load_balancer_arn = aws_alb.ecs-alb.arn
  port = "8080"
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.ecs-alb-target.arn
  }
}

resource "aws_alb_target_group" "ecs-alb-target" {
  name = "ecs-sphfs-target"
  port = "80"
  protocol = "HTTP"
  target_type = "ip"
  vpc_id = module.vpc.vpc_id
}

output "sphfs-dns" {
  value = aws_alb.ecs-alb.dns_name
}
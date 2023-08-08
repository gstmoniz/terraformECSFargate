resource "aws_security_group" "alb-sc" {
  name = "alb-securityGroup"
  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group_rule" "alb-sc-http" {
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = [ "0.0.0.0/0" ]
  security_group_id = aws_security_group.alb-sc.id
}

resource "aws_security_group_rule" "alb-sc-https" {
  type = "ingress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  cidr_blocks = [ "0.0.0.0/0" ]
  security_group_id = aws_security_group.alb-sc.id
}

resource "aws_security_group_rule" "alb-sc-out" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = [ "0.0.0.0/0" ]
  security_group_id = aws_security_group.alb-sc.id
}

# ECS Security Group -----

resource "aws_security_group" "ecs-sc" {
  name = "ecs-securityGroup"
  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group_rule" "ecs-sc-in" {
  source_security_group_id = aws_security_group.alb-sc.id
  type = "ingress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  security_group_id = aws_security_group.ecs-sc.id
}

resource "aws_security_group_rule" "ecs-sc-out" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = [ "0.0.0.0/0" ]
  security_group_id = aws_security_group.ecs-sc.id
}
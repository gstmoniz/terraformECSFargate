resource "aws_security_group" "alb-sc" {
  name = "alb-securityGroup"
  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group_rule" "alb-sc-in" {
  type = "ingress"
  from_port = 8080
  to_port = 8080
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
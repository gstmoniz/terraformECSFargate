module "ecs" {
  source = "terraform-aws-modules/ecs/aws"

  cluster_name = "ecs-fargate"
  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 100
      }
    }
  }
}

resource "aws_ecs_task_definition" "app-node" {
  family = "app-node-family"
  cpu = 256
  memory = 512
  network_mode = "awsvpc"
  requires_compatibilities = [ "FARGATE" ]
  
  container_definitions = jsonencode([{
      "name" = "app-container"
      "image" = "docker.io/gstmoniz/app-node:1.4"
      "cpu" = 256
      "memory" = 512
      "essential" = true
      "portMappings" = [{
          "containerPort" = 6000
          "hostPort" = 6000
        }
      ]
    }]
  )
}

resource "aws_ecs_service" "app-node" {
  name = "app-node-service"
  cluster = module.ecs.cluster_id
  task_definition = aws_ecs_task_definition.app-node.arn
  desired_count = 3

  load_balancer {
    target_group_arn = aws_alb_target_group.ecs-alb-target.arn
    container_name = "app-container"
    container_port = 6000
  }

  network_configuration {
    subnets = module.vpc.private_subnets
    security_groups = [ aws_security_group.ecs-sc.id ]
  }
}
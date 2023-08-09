module "ecs" {
  source = "terraform-aws-modules/ecs/aws"

  cluster_name = "sphfs-ecs-fargate"
  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 100
      }
    }
  }
}

data "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
}

resource "aws_ecs_task_definition" "sphfs" {
  family = "sphfs-family"
  cpu = 256
  memory = 512
  network_mode = "awsvpc"
  requires_compatibilities = [ "FARGATE" ]
  execution_role_arn = "${data.aws_iam_role.ecs_task_execution_role.arn}"
  
  container_definitions = jsonencode([{
      "name" = "sphfs-container"
      "image" = "docker.io/gstmoniz/temp-nginx:latest"
      "cpu" = 256
      "memory" = 512
      "essential" = true
      "portMappings" = [{
          "containerPort" = 8080
          "hostPort" = 8080
        }
      ]
    }]
  )
}

resource "aws_ecs_service" "sphfs" {
  name = "sphfs-service"
  cluster = module.ecs.cluster_id
  task_definition = aws_ecs_task_definition.sphfs.arn
  desired_count = 1

  load_balancer {
    target_group_arn = aws_alb_target_group.ecs-alb-target.arn
    container_name = "sphfs-container"
    container_port = 8080
  }

  network_configuration {
    subnets = module.vpc.private_subnets
    security_groups = [ aws_security_group.ecs-sc.id ]
  }
}
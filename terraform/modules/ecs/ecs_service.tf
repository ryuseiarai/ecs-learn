#################################################
# ECS Service
#################################################

resource "aws_ecs_service" "backend" {
  name            = var.ecs.service.backend.name
  cluster         = aws_ecs_cluster.backend.id
  task_definition = aws_ecs_task_definition.backend.arn

  desired_count                      = var.ecs.service.backend.instance_num
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100

  launch_type = "FARGATE"

  network_configuration {
    subnets         = [for name in var.ecs.service.backend.subnets_name : var.subnet_ids[name]]
    security_groups = [var.sg_ids[var.ecs.service.backend.sg_name]]
  }

  dynamic "load_balancer" {
    for_each = var.ecs.service.backend.lb
    content {
      target_group_arn = var.lb.target_group_arn[load_balancer.value.tg_name]
      container_name   = var.ecs.task.backend.container_name
      container_port   = load_balancer.value.port
    }

  }

}

resource "aws_ecs_service" "frontend" {
  name            = var.ecs.service.frontend.name
  cluster         = aws_ecs_cluster.frontend.id
  task_definition = aws_ecs_task_definition.frontend.arn

  desired_count                      = var.ecs.service.frontend.instance_num
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100

  launch_type = "FARGATE"

  network_configuration {
    subnets         = [for name in var.ecs.service.frontend.subnets_name : var.subnet_ids[name]]
    security_groups = [var.sg_ids[var.ecs.service.frontend.sg_name]]
  }

  dynamic "load_balancer" {
    for_each = var.ecs.service.frontend.lb
    content {
      target_group_arn = var.lb.target_group_arn[load_balancer.value.tg_name]
      container_name   = var.ecs.task.frontend.container_name
      container_port   = load_balancer.value.port
    }

  }

}
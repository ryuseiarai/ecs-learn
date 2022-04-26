#################################################
# タスク定義
#################################################

resource "aws_ecs_task_definition" "backend" {
  family                   = var.ecs.task.backend.name
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.ecs.task.backend.cpu
  memory                   = var.ecs.task.backend.memory
  execution_role_arn       = var.iam.role_arn.ecs_task_execution

  container_definitions = templatefile("${path.module}/template/ecs_task_backend_def_template.json",
    {
      image_uri      = "${var.ecr.backend_uri}:${var.ecs.task.backend.tag}",
      container_name = var.ecs.task.backend.container_name
      def_name       = var.ecs.task.backend.name
      db_host        = var.db.host
      db_name        = var.db.dbname
      db_username    = var.db.username
      db_password    = var.db.password
    }
  )
}

resource "aws_ecs_task_definition" "frontend" {
  family                   = var.ecs.task.frontend.name
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.ecs.task.frontend.cpu
  memory                   = var.ecs.task.frontend.memory
  execution_role_arn       = var.iam.role_arn.ecs_task_execution

  container_definitions = templatefile("${path.module}/template/ecs_task_frontend_def_template.json",
    {
      image_uri          = "${var.ecr.frontend_uri}:${var.ecs.task.frontend.tag}",
      container_name     = var.ecs.task.frontend.container_name
      def_name           = var.ecs.task.frontend.name
      app_service_host   = var.lb.dns_name[var.ecs.task.frontend.lb_name]
      notif_service_host = var.lb.dns_name[var.ecs.task.frontend.lb_name]
      db_host            = var.db.host
      db_name            = var.db.dbname
      db_username        = var.db.username
      db_password        = var.db.password
    }
  )
}
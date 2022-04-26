#################################################
# ECS Cluster
#################################################
resource "aws_ecs_cluster" "backend" {
  name = var.ecs.cluster.backend.name

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_cluster" "frontend" {
  name = var.ecs.cluster.frontend.name

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}
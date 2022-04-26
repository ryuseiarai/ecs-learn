#################################################
# Load Balancer
#################################################

#ALB
## Backend
resource "aws_lb" "this" {
  for_each           = { for i in var.lb.lb : i.name => i }
  name               = each.value.name
  internal           = each.value.internal
  load_balancer_type = lookup(each.value, "load_balancer_type", "application")
  security_groups    = [var.sg_ids[each.value.sg_name]]
  subnets            = [for name in each.value.subnets_name : var.subnet_ids[name]]
}

# Target Group
resource "aws_lb_target_group" "this" {
  for_each    = { for i in var.lb.tg : i.name => i }
  name        = each.value.name
  target_type = each.value.type
  port        = each.value.port
  protocol    = each.value.protocol
  vpc_id      = var.vpc_id

  health_check {
    path              = each.value.health_check.path
    healthy_threshold = each.value.health_check.healthy_threshold
    timeout           = each.value.health_check.timeout
    interval          = each.value.health_check.interval
    matcher           = 200
  }
}

# Listener
resource "aws_lb_listener" "this" {
  for_each          = { for i in var.lb.listener : i.name => i }
  load_balancer_arn = aws_lb.this[each.value.lb_name].arn
  port              = each.value.port
  protocol          = each.value.protocol

  default_action {
    type             = each.value.action.type
    target_group_arn = aws_lb_target_group.this[each.value.action.tg_name].arn
  }
}

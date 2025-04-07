resource "aws_lb_target_group" "ecs_tg" {
  name        = "${local.app.name}-tg"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = data.terraform_remote_state.common.outputs.aws_vpc_main_id
  target_type = "ip"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    interval            = 30
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

resource "aws_lb_listener_rule" "app_rule" {
  listener_arn = data.terraform_remote_state.common.outputs.aws_lb_listener_lb_http_arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_tg.arn
  }

  condition {
    path_pattern {
      values = ["/app*"]
    }
  }
}

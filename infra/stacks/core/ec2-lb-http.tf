resource "aws_lb_listener" "lb_http" {
  load_balancer_arn = aws_lb.app_lb[0].arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "${aws_lb.app_lb[0].name} is up"
      status_code  = "200"
    }
  }
}

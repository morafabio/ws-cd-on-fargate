resource "aws_ecs_service" "web" {
  name            = "${local.app.name}-web"

  cluster         = data.terraform_remote_state.common.outputs.aws_ecs_cluster_main_id
  task_definition = aws_ecs_task_definition.app_web.arn
  desired_count   = local.app.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = data.terraform_remote_state.common.outputs.aws_subnet_public_ids
    security_groups = [data.terraform_remote_state.common.outputs.aws_security_group_alb_sg_id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_tg.arn
    container_name   = "app"
    container_port   = 8080
  }
}

resource "aws_ecs_task_definition" "app_web" {
  family             = "${local.app.name}-web"
  network_mode       = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                = "256"
  memory             = "512"

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "app"
      image     = "${aws_ecr_repository.app_web.repository_url}:486baf03a79665d3afacc61406d0a324bd6c86ec"
      essential = true
      healthCheck = {
        command     = ["CMD-SHELL", "curl -f http://localhost:8080/ || exit 1"]
        interval    = 15
        timeout     = 5
        retries     = 3
        startPeriod = 5
      }
      portMappings = [
        { containerPort = 8080, hostPort = 8080 }
      ]
    }
  ])
}

resource "aws_ecs_service" "web" {
  name            = "${local.app.name}-web"

  cluster         = data.terraform_remote_state.common.outputs.aws_ecs_cluster-main-id
  task_definition = aws_ecs_task_definition.app_web.arn
  desired_count   = local.app.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = [data.terraform_remote_state.common.outputs.aws_subnet-public_id]
    security_groups = [data.terraform_remote_state.common.outputs.aws_security_group-alb_sg-id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.tg.arn
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
      image     = "${aws_ecr_repository.app_web.repository_url}:latest"
      essential = true
      portMappings = [
        { containerPort = 8080, hostPort = 8080 }
      ]
    }
  ])
}

resource "aws_lb_target_group" "tg" {
  name        = "${local.app.name}-web"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = data.terraform_remote_state.common.outputs.aws_vpc-main-id
  target_type = "ip"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    interval            = 30
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = data.terraform_remote_state.common.outputs.aws_lb-app_lb-arn
  port              = 80
  protocol          = "HTTP"
  count = 0

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Service = "ecs-tasks.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
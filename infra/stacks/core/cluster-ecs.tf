resource "aws_ecs_cluster" "main" {
  name = "${local.org_name}-dev"
}


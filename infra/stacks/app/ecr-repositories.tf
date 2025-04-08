resource "aws_ecr_repository" "app_web" {
  name         = "${local.org-name}/${local.app.name}/web"
  force_delete = true
}

resource "aws_ecr_lifecycle_policy" "lpa_webapp_policy" {
  repository = aws_ecr_repository.app_web.name
  policy = jsonencode({
    rules = [
      {
        rulePriority = 10,
        selection = { tagStatus = "any", countType = "imageCountMoreThan", countNumber = 3 },
        action = { type = "expire" }
      }
    ]
  })
}
resource "github_repository" "ws_cd_on_fargate" {
  name               = "ws-cd-on-fargate"
  visibility         = "public"
  has_issues         = false
  has_wiki           = false

  allow_merge_commit = true
  allow_squash_merge = false
  allow_rebase_merge = false

  lifecycle {
    prevent_destroy = true
  }
}

resource "github_actions_secret" "tf_var_github_token" {
  repository      = github_repository.ws_cd_on_fargate.name
  secret_name     = "TF_VAR_GITHUB_TOKEN"
  plaintext_value = var.github_token
  lifecycle {
    prevent_destroy = true
  }
}

resource "github_actions_secret" "dockerhub_token" {
  repository      = github_repository.ws_cd_on_fargate.name
  secret_name     = "DOCKERHUB_TOKEN"
  plaintext_value = var.dockerhub_token
}

resource "github_actions_secret" "dockerhub_username" {
  repository      = github_repository.ws_cd_on_fargate.name
  secret_name     = "DOCKERHUB_USERNAME"
  plaintext_value = var.dockerhub_username
}

resource "github_actions_secret" "aws_access_key_id" {
  repository      = github_repository.ws_cd_on_fargate.name
  secret_name     = "AWS_ACCESS_KEY_ID"
  plaintext_value = var.aws_access_key_id
}

resource "github_actions_secret" "aws_secret_access_key" {
  repository      = github_repository.ws_cd_on_fargate.name
  secret_name     = "AWS_SECRET_ACCESS_KEY"
  plaintext_value = var.aws_secret_access_key
}

resource "github_actions_secret" "aws_default_region" {
  repository      = github_repository.ws_cd_on_fargate.name
  secret_name     = "AWS_DEFAULT_REGION"
  plaintext_value = var.aws_region
}

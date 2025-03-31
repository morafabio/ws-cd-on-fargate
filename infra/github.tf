resource "github_repository" "ws_cd_on_fargate" {
  name        = "ws-cd-on-fargate"
  visibility  = "public"
  has_issues  = false
  has_wiki    = false
  allow_merge_commit = true
  allow_squash_merge = false
  allow_rebase_merge = false
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

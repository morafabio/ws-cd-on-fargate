provider "github" {
  token = var.github_token
  owner = "morafabio"
}

provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
}
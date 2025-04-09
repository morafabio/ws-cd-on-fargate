locals {
  org-name = data.terraform_remote_state.common.outputs.org_name

  app = {
    name          = "app-cd-on-fargate"
    desired_count = 1
  }
}

data "terraform_remote_state" "common" {
  backend = "s3"

  config = {
    bucket = "techeffe-terraform-states"
    key    = "core.tfstate"
    region = "us-east-1"
  }
}


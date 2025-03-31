terraform {
  required_version = ">= 1.0, < 2.0"

  required_providers {
    # aws = {
    #   source  = "hashicorp/aws"
    #   version = "~> 5.0"
    # }
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}
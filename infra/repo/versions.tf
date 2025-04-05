terraform {
  required_version = ">= 1.0, < 2.0"

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
    ovh = {
      source = "ovh/ovh"
    }
  }
}

provider "ovh" {
  endpoint      = "ovh-eu"
  client_id     = "xxxxxxxxx"
  client_secret = "yyyyyyyyy"
}
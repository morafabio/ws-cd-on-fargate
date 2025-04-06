terraform {
  backend "s3" {
    bucket = "techeffe-terraform-states"
    key    = "core.tfstate"
    region = "us-east-1"
  }
}

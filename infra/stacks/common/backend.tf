terraform {
  backend "s3" {
    bucket = "techeffe-terraform-states"
    key    = "common.tfstate"
    region = "us-east-1"
  }
}

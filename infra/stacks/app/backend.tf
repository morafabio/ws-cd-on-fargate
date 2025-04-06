terraform {
  backend "s3" {
    bucket = "techeffe-terraform-states"
    key    = "app.tfstate"
    region = "us-east-1"
  }
}

locals {
  org_name   = "tf"

  enable_alb = true

  network = {
    vpc_cidr            = "10.0.0.0/16"
    public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
    availability_zones  = ["${var.aws_region}a", "${var.aws_region}b"]
  }
}
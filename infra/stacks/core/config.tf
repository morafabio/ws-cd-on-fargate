locals {
  org-name = "tf"

  network = {
    vpc_cidr = "10.0.0.0/16"
    public_subnet_cidr = "10.0.1.0/24"
    availability_zone = "${var.aws_region}a"
  }
}

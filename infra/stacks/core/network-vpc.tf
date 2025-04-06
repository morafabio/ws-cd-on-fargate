resource "aws_vpc" "main" {
  cidr_block           = local.network.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_subnet" "public" {
  count                   = length(local.network.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = local.network.public_subnet_cidrs[count.index]
  availability_zone       = local.network.availability_zones[count.index]
  map_public_ip_on_launch = true
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.igw.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "public" {
  for_each = { for idx, subnet in aws_subnet.public : idx => subnet.id }
  subnet_id      = each.value
  route_table_id = aws_route_table.public.id
}

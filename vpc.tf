###############################################################################
# 
# VPC
#
###############################################################################

resource "aws_vpc" "main" {
  cidr_block       = var.vpc_main_cidr_block
  instance_tenancy = "default"

  tags             = {
    Name           = "main"
  }
}

resource "aws_subnet" "subnet-main" {
  count             = length(data.aws_availability_zones.all.names)
  vpc_id            = aws_vpc.main.id
  availability_zone = data.aws_availability_zones.all.names[count.index]

  cidr_block        = element(var.secondary_cidr_blocks, count.index)
  map_public_ip_on_launch = "true"

  tags             = {
    Name           = "subnet-main-${count.index}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id            = aws_vpc.main.id

  tags              = {
    Name            = "igw-main"
  }
}

resource "aws_route" "rt-igw-main" {
  route_table_id         = aws_vpc.main.default_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

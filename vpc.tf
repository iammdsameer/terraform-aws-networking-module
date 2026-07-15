resource "aws_vpc" "this" {
  cidr_block = var.vpc_config.cidr_block

  tags = {
    Name = var.vpc_config.name
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "this" {
  for_each          = var.subnet_config
  vpc_id            = aws_vpc.this.id
  availability_zone = each.value.az
  cidr_block        = each.value.cidr_block

  lifecycle {
    precondition {
      condition     = contains(data.aws_availability_zones.available.names, each.value.az)
      error_message = format("The AZ %s is not one of available region. Choose a different one.", each.value.az)
    }
  }

  tags = {
    Name = each.key
    Type = each.value.public ? "Public" : "Private"
  }
}

locals {
  public_subnets = {
    for subnet_name, config in var.subnet_config : subnet_name => config if config.public
  }
  private_subnets = {
    for subnet_name, config in var.subnet_config : subnet_name => config if !config.public
  }
}

resource "aws_internet_gateway" "igw" {
  count  = length(local.public_subnets) > 0 ? 1 : 0
  vpc_id = aws_vpc.this.id
}

resource "aws_route_table" "this" {
  count  = length(aws_internet_gateway.igw)
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw[0].id
  }
}

resource "aws_route_table_association" "this" {
  for_each       = local.public_subnets
  subnet_id      = aws_subnet.this[each.key].id
  route_table_id = aws_route_table.this[0].id
}

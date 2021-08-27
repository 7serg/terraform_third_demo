/*
provider "aws" {
  region = var.aws_region

}


# Backend remote state configuration

terraform {
  backend "s3" {
    bucket = "malkosergeyseconddemoecs"
    region = "eu-central-1"
    key    = "staging/infrastructure/terraform.tfstate"
  }
}
*/


data "aws_availability_zones" "available" {
  state = "available"
}

# VPC creation
resource "aws_vpc" "demoecs_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${var.env}-${var.app_name}-VPC"
  }
}


#Internet gateway creation_date



resource "aws_internet_gateway" "demoecs" {
  vpc_id = aws_vpc.demoecs_vpc.id
  tags = {
    Name = "${var.env}-${var.app_name}-igw"
  }
}


# Subnets creation

resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnets_cidr)
  vpc_id                  = aws_vpc.demoecs_vpc.id
  cidr_block              = element(var.public_subnets_cidr, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "public_subnet-${var.env}-${var.app_name}-${count.index + 1}"
  }

}


# Routing table for public subnets

resource "aws_route_table" "public_subnets" {
  vpc_id = aws_vpc.demoecs_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demoecs.id

  }
  tags = {
    Name = "${var.env}-${var.app_name}-public-route-table"
  }

  depends_on = [aws_internet_gateway.demoecs]

}

# Routing table association

resource "aws_route_table_association" "public_routes" {
  count          = length(aws_subnet.public_subnets[*].id)
  route_table_id = aws_route_table.public_subnets.id
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
}


# Creating private subnets

resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnets_cidr)
  vpc_id            = aws_vpc.demoecs_vpc.id
  cidr_block        = element(var.private_subnets_cidr, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "${var.env}-${var.app_name}-${count.index + 1}-private-subnet"
  }

}

#Elastic IPs for NAT gateways
resource "aws_eip" "elastic_ip_for_nat" {
  count = length(var.private_subnets_cidr)
  vpc   = true
  tags = {
    Name = "${var.env}-${var.app_name}-${count.index + 1}-EIP"
  }

}


# Creation NAT gateway

resource "aws_nat_gateway" "for_private_subnets" {
  count         = length(var.public_subnets_cidr)
  allocation_id = element(aws_eip.elastic_ip_for_nat[*].id, count.index)
  subnet_id     = element(aws_subnet.public_subnets[*].id, count.index)
  tags = {
    Name = "Nat_gw-${data.aws_availability_zones.available.names[count.index]}-${count.index + 1}-${var.env}-${var.app_name}"
  }
  depends_on = [aws_eip.elastic_ip_for_nat]

}
#Route table for private subnets

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.demoecs_vpc.id
  count  = length(var.private_subnets_cidr)
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.for_private_subnets[count.index].id
  }
  tags = {
    Name = "RT-${data.aws_availability_zones.available.names[count.index]}-${count.index + 1}-${var.env}-${var.app_name}"
  }

}



resource "aws_route_table_association" "private_routes" {
  count          = length(aws_subnet.private_subnets[*].id)
  route_table_id = aws_route_table.private[count.index].id
  subnet_id      = element(aws_subnet.private_subnets[*].id, count.index)
}

# availability zones
data "aws_availability_zones" "available" {}
# vpc
resource "aws_vpc" "vpc" {
  cidr_block                           = var.vpc_cidr
  instance_tenancy                     = "default"
  enable_dns_support                   = true
  enable_network_address_usage_metrics = true
  enable_dns_hostnames                 = true # objects have dns name

  tags = {
    "Name" = "${var.deployment_prefix}-vpc"
  }
}
# public subnets
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.public_subnets_cidr)
  cidr_block              = var.public_subnets_cidr[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    "Name" = "${var.deployment_prefix}-public-subnets-${count.index + 1}"
  }
}
# public subnets
resource "aws_subnet" "jenkins" {
  vpc_id            = aws_vpc.vpc.id
  count             = length(var.jenkins_subnets_cidr)
  cidr_block        = var.jenkins_subnets_cidr[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    "Name" = "${var.deployment_prefix}-jenkins-subnet-${count.index + 1}"
  }
}
# app subnets
resource "aws_subnet" "app" {
  vpc_id            = aws_vpc.vpc.id
  count             = length(var.app_subnets_cidr)
  cidr_block        = var.app_subnets_cidr[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    "Name" = "${var.deployment_prefix}-app-subnet-${count.index + 1}"
  }
}
# rds mysql subnets
resource "aws_subnet" "rds_mysql" {
  vpc_id            = aws_vpc.vpc.id
  count             = length(var.rds_mysql_subnets_cidr)
  cidr_block        = var.rds_mysql_subnets_cidr[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    "Name" = "${var.deployment_prefix}-rds-mysql-subnet-${count.index + 1}"
  }
}
# igw
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    "Name" = "${var.deployment_prefix}-myigw"
  }
}
# static ip for nat
resource "aws_eip" "nat_eip" {
  tags = {
    "Name" = "${var.deployment_prefix}-nat-eip"
  }
}
# nat
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public[0].id
  tags = {
    "Name" = "${var.deployment_prefix}-nat"
  }
}
# igw rt
resource "aws_route_table" "igw_rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    "Name" = "${var.deployment_prefix}-igw-rt"
  }
}
# nat rt 
resource "aws_route_table" "nat_rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    "Name" = "${var.deployment_prefix}-nat-rt"
  }
}
# link public subnets to igw
resource "aws_route_table_association" "public_subnets_rt" {
  count          = length(var.public_subnets_cidr)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.igw_rt.id
}
# link jenkins subnets to nat
resource "aws_route_table_association" "jenkins_subnets_rt" {
  count          = length(var.jenkins_subnets_cidr)
  subnet_id      = aws_subnet.jenkins[count.index].id
  route_table_id = aws_route_table.nat_rt.id
}

# link app subnets to nat
resource "aws_route_table_association" "app" {
  count          = length(var.app_subnets_cidr)
  subnet_id      = aws_subnet.app[count.index].id
  route_table_id = aws_route_table.nat_rt.id
}

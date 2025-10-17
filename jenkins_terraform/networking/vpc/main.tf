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
# jenkins subnets
resource "aws_subnet" "jenkins" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.jenkins_subnets_cidr)
  cidr_block              = var.jenkins_subnets_cidr[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    "Name" = "${var.deployment_prefix}-jenkins-subnet-${count.index + 1}"
  }
}
# jenkins workers
resource "aws_subnet" "jenkins_workers" {
  vpc_id            = aws_vpc.vpc.id
  count             = length(var.workers_subnets_cidr)
  cidr_block        = var.workers_subnets_cidr[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    "Name" = "${var.deployment_prefix}-workers-subnet-${count.index + 1}"
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
# db subnets
resource "aws_subnet" "db" {
  vpc_id            = aws_vpc.vpc.id
  count             = length(var.db_subnets_cidr)
  cidr_block        = var.db_subnets_cidr[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    "Name" = "${var.deployment_prefix}-db-subnet-${count.index + 1}"
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
  count = 1
  tags = {
    "Name" = "${var.deployment_prefix}-nat-eip"
  }
}
# nat into jenkins subnet for private subnets
resource "aws_nat_gateway" "nat" {
  count         = 1
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.jenkins.id
  tags = {
    "Name" = "${var.deployment_prefix}-nat}"
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
# link igw rt to jenkins subnets
resource "aws_route_table_association" "jenkins" {
  subnet_id      = aws_subnet.jenkins.id
  route_table_id = aws_route_table.igw_rt.id
}
# link nat to jenkins workers subnet
resource "aws_route_table_association" "jenkins_workers" {
  subnet_id      = aws_subnet.jenkins_workers.id
  route_table_id = aws_route_table.nat_rt.id
}
# link nat to apps subnet
resource "aws_route_table_association" "app" {
  count          = length(var.app_subnets_cidr)
  subnet_id      = aws_subnet.jenkins_workers[count.index].id
  route_table_id = aws_route_table.nat_rt.id
}

resource "aws_vpc" "eks-vpc" {
  cidr_block       = var.cidr_block
  instance_tenancy = "default"
  enable_dns_hostnames = true

  tags = {
    "Name" = var.cluster_name
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_internet_gateway" "eks-vpc-igw" {
  vpc_id = aws_vpc.eks-vpc.id
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "eks-public-1" {
  vpc_id     = aws_vpc.eks-vpc.id
  cidr_block = var.subnet1_cidr
  availability_zone = var.az1
  map_public_ip_on_launch = true

  tags = {
    Name = var.subnet_name1
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_subnet" "eks-public-2" {
  vpc_id     = aws_vpc.eks-vpc.id
  cidr_block = var.subnet2_cidr
  availability_zone = var.az2
  map_public_ip_on_launch = true

  tags = {
    Name = var.subnet_name2
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_subnet" "eks-public-3" {
  vpc_id     = aws_vpc.eks-vpc.id
  cidr_block = var.subnet3_cidr
  availability_zone = var.az3
  map_public_ip_on_launch = true

  tags = {
    Name = var.subnet_name3
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_route_table" "eks-public-rt" {
    vpc_id = aws_vpc.eks-vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.eks-vpc-igw.id
    }

    tags = {
        Name = var.rt_name
    }
}

resource "aws_route_table_association" "eks-public-rt1a" {
    subnet_id = aws_subnet.eks-public-1.id
    route_table_id = aws_route_table.eks-public-rt.id
}
resource "aws_route_table_association" "eks-public-rt1b" {
    subnet_id = aws_subnet.eks-public-2.id
    route_table_id = aws_route_table.eks-public-rt.id
}
resource "aws_route_table_association" "eks-public-rt1c" {
    subnet_id = aws_subnet.eks-public-3.id
    route_table_id = aws_route_table.eks-public-rt.id
}
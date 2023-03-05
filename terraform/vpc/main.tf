##  core  ###
resource "aws_vpc" "kubernetes" {
  cidr_block           = var.cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.name}-vpc"

    "kubernetes.io/cluster/${var.name}" = "owned"

  }

}


resource "aws_internet_gateway" "gw" {
  vpc_id = (aws_vpc.kubernetes.id)

  tags = {
    Name = "${var.name}-igw"

    "kubernetes.io/cluster/${var.name}" = "owned"
  }
}


resource "aws_subnet" "private" {
  vpc_id            = (aws_vpc.kubernetes.id)
  cidr_block        = "10.76.161.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "${var.name}-Private-1ba"

    "kubernetes.io/cluster/${var.name}" = "owned"
    "kubernetes.io/role/internal-elb"   = "1"
  }
}


resource "aws_subnet" "private1" {
  vpc_id            = (aws_vpc.kubernetes.id)
  cidr_block        = "10.76.162.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "${var.name}-Private-1b"

    "kubernetes.io/cluster/${var.name}" = "owned"
    "kubernetes.io/role/internal-elb"   = "1"
  }
}




resource "aws_subnet" "public" {
  vpc_id                  = (aws_vpc.kubernetes.id)
  cidr_block              = "10.76.167.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.name}-Public-1a"

    "kubernetes.io/cluster/${var.name}" = "owned"
    "kubernetes.io/role/elb"            = "1"
  }
}


resource "aws_subnet" "public1" {
  vpc_id                  = (aws_vpc.kubernetes.id)
  cidr_block              = "10.76.168.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.name}-public-1b"

    "kubernetes.io/cluster/${var.name}" = "owned"
    "kubernetes.io/role/elb"            = "1"
  }
}


resource "aws_subnet" "rds" {
  vpc_id            = (aws_vpc.kubernetes.id)
  cidr_block        = "10.76.163.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "${var.name}-rds-1a"

    "kubernetes.io/cluster/${var.name}" = "owned"
  }
}

resource "aws_subnet" "rds1" {
  vpc_id            = (aws_vpc.kubernetes.id)
  cidr_block        = "10.76.164.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "${var.name}-rds-1b"

    "kubernetes.io/cluster/${var.name}" = "owned"
  }
}




provider "aws" {
  region = var.region
}

resource "aws_vpc" "module_vpc" {
  cidr_block = var.vpc_cidr_block
  enable_dns_hostnames = true

  tags = {
    Name="DEV-VPC"
  }
}

resource "aws_subnet" "dev-subnet-private1-us-east-1a" {
  cidr_block = var.private_subnet_1_cidr
  vpc_id = aws_vpc.module_vpc.id
  availability_zone = "${var.region}a"

  tags = {
    Name="Private-Subnet-1"
  }
}

resource "aws_subnet" "dev-subnet-private2-us-east-1b" {
  cidr_block = var.private_subnet_2_cidr
  vpc_id = aws_vpc.module_vpc.id
  availability_zone = "${var.region}b"

  tags = {
    Name="Private-Subnet-2"
  }
}

resource "aws_subnet" "dev-subnet-public1-us-east-1a" {
  cidr_block = var.public_subnet_1_cidr
  vpc_id = aws_vpc.module_vpc.id
  availability_zone = "${var.region}a"

  tags = {
    Name="Public-Subnet-1"
  }
}
resource "aws_subnet" "dev-subnet-public2-us-east-1b" {
  cidr_block = var.public_subnet_2_cidr
  vpc_id = aws_vpc.module_vpc.id
  availability_zone = "${var.region}b"

  tags = {
    Name="Public-Subnet-2"
  }
}

resource "aws_route_table" "dev-rtb-private1-us-east-1a" {
  vpc_id = aws_vpc.module_vpc.id
  tags = {
    Name="Private-Route-Table-1a"
  }
}

resource "aws_route_table" "dev-rtb-private2-us-east-1b" {
  vpc_id = aws_vpc.module_vpc.id
  tags = {
    Name="Private-Route-Table-1b"
  }
}

resource "aws_route_table" "dev-rtb-public2-us-east-1b" {
  vpc_id = aws_vpc.module_vpc.id
  tags = {
    Name="Public-Route-Table-1b"
  }
}

resource "aws_route_table" "dev-rtb-public1-us-east-1a" {
  vpc_id = aws_vpc.module_vpc.id
  tags = {
    Name="Public-Route-Table-1a"
  }
}

resource "aws_route_table_association" "dev-association-private1-us-east-1a" {
  route_table_id = aws_route_table.dev-rtb-private1-us-east-1a.id
  subnet_id = aws_subnet.dev-subnet-private1-us-east-1a.id
}

resource "aws_route_table_association" "dev-association-private2-us-east-1b" {
  route_table_id = aws_route_table.dev-rtb-private2-us-east-1b.id
  subnet_id = aws_subnet.dev-subnet-private2-us-east-1b.id
}

resource "aws_route_table_association" "dev-association-public1-us-east-1a" {
  route_table_id = aws_route_table.dev-rtb-public1-us-east-1a.id
  subnet_id = aws_subnet.dev-subnet-public1-us-east-1a.id
}

resource "aws_route_table_association" "dev-association-public2-us-east-1a" {
  route_table_id = aws_route_table.dev-rtb-public2-us-east-1b.id
  subnet_id = aws_subnet.dev-subnet-public2-us-east-1b.id
}

resource "aws_eip" "elastic_ip_for_nat_gw" {
  vpc = true
  associate_with_private_ip = var.eip_association_address

  tags = {
    Name="DEV-EIP"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.elastic_ip_for_nat_gw.id
  subnet_id = aws_subnet.dev-subnet-public1-us-east-1a.id

  tags = {
    Name="DEV-NAT-GW"
  }
}

resource "aws_route" "nat_gateway_route" {
  route_table_id = aws_route_table.dev-rtb-private1-us-east-1a.id
  nat_gateway_id = aws_nat_gateway.nat_gateway.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route" "nat_gateway_route1" {
  route_table_id = aws_route_table.dev-rtb-private2-us-east-1b.id
  nat_gateway_id = aws_nat_gateway.nat_gateway.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.module_vpc.id

  tags = {
    Name="DEV-IGW"
  }
}

resource "aws_route" "igw_route" {
  route_table_id = aws_route_table.dev-rtb-public1-us-east-1a.id
  gateway_id = aws_internet_gateway.internet_gateway.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route" "igw_route1" {
  route_table_id = aws_route_table.dev-rtb-public2-us-east-1b.id
  gateway_id = aws_internet_gateway.internet_gateway.id
  destination_cidr_block = "0.0.0.0/0"
}


resource "aws_security_group" "Instance-SG" {
  name = "Instance-SG"
  vpc_id = aws_vpc.module_vpc.id

  ingress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    security_groups = [aws_security_group.dev-sg-elb.id]
  }

  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
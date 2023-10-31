# Creates the VPC-01
resource "aws_vpc" "vpc-01" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "VPC-01"
  }
}

# Created a public subnet named Sub-A
resource "aws_subnet" "sub-a-public" {
  vpc_id            = aws_vpc.vpc-01.id
  availability_zone = "us-east-1a"
  cidr_block        = "10.0.1.0/24"

  tags = {
    Name = "Sub-A-Public"
    Role = "public"
    # Subnet      = ""
  }
}

# Created a public subnet named Sub-B
resource "aws_subnet" "sub-b-public" {
  vpc_id            = aws_vpc.vpc-01.id
  availability_zone = "us-east-1b"
  cidr_block        = "10.0.2.0/24"

  tags = {
    Name = "Sub-B-Public"
    Role = "public"
    # Subnet      = ""
  }
}


# Creates a private subnet names Sub-C
resource "aws_subnet" "sub-c-private" {
  vpc_id            = aws_vpc.vpc-01.id
  availability_zone = "us-east-1c"
  cidr_block        = "10.0.3.0/24"

  tags = {
    Name = "Sub-C-Private"
    Role = "private"
    # Subnet      = ""
  }
}

# Creates a private subnet names Sub-D
resource "aws_subnet" "sub-d-private" {
  vpc_id            = aws_vpc.vpc-01.id
  availability_zone = "us-east-1d"
  cidr_block        = "10.0.4.0/24"

  tags = {
    Name = "Sub-D-Private"
    Role = "private"
    # Subnet      = ""
  }
}

resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = aws_vpc.vpc-01.id

  tags = {
    Name = "VPC-IGW"
  }
}

resource "aws_eip" "eip-sub-a" {
  domain   = "vpc"

  tags = {
    Name = "Sub-A Elastic IP"
  }
}


resource "aws_nat_gateway" "public-nat-gateway" {
  allocation_id = aws_eip.eip-sub-a.id
  subnet_id     = aws_subnet.sub-a-public.id

  tags = {
    Name = "Sub-A NAT Gateway"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.internet-gateway]
}



resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.vpc-01.id

  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = "local"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gateway.id
  }

  tags = {
    Name = "VPC-01-RT-Public"
  }
}

resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.vpc-01.id

  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = "local"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.public-nat-gateway.id
  }

  tags = {
    Name = "VPC-01-RT-Private"
  }
}

resource "aws_route_table_association" "associate-sub-a-public-rt" {
  subnet_id      = aws_subnet.sub-a-public.id
  route_table_id = aws_route_table.public-route-table.id
}

resource "aws_route_table_association" "associate-sub-b-public-rt" {
  subnet_id      = aws_subnet.sub-b-public.id
  route_table_id = aws_route_table.public-route-table.id
}

resource "aws_route_table_association" "associate-sub-c-private-rt" {
  subnet_id      = aws_subnet.sub-c-private.id
  route_table_id = aws_route_table.private-route-table.id
}

resource "aws_route_table_association" "associate-sub-d-private-rt" {
  subnet_id      = aws_subnet.sub-d-private.id
  route_table_id = aws_route_table.private-route-table.id
}



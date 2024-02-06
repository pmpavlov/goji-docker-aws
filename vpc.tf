data "aws_availability_zones" "available" {
  state = "available"
}

# Create a VPC
resource "aws_vpc" "goji" {
  cidr_block = var.vpc_cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true
  instance_tenancy = "default"
  tags = {
    Name = "goji-vpc"
  }
}

#Create Internet GateWay 
resource "aws_internet_gateway" "goji-igw" {
  vpc_id = aws_vpc.goji.id

  tags = {
    Name = "goji-igw"
  }
}

# Create public subnet in first AZ
resource "aws_subnet" "public_subnet_1" {
  vpc_id     = aws_vpc.goji.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-1a"
  }
}

# Create private subnet in first AZ
resource "aws_subnet" "private_subnet_1" {
  vpc_id     = aws_vpc.goji.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
  tags = {
    Name = "private-subnet-1a"
  }
}

# Create database subnet in first AZ
resource "aws_subnet" "db_subnet_1" {
  vpc_id     = aws_vpc.goji.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
  tags = {
    Name = "db-subnet-1a"
  }
}

# Create public subnet in second AZ
resource "aws_subnet" "public_subnet_2" {
  vpc_id     = aws_vpc.goji.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-2b"
  }
}

# Create private subnet in second AZ
resource "aws_subnet" "private_subnet_2" {
  vpc_id     = aws_vpc.goji.id
  cidr_block = "10.0.5.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"
  tags = {
    Name = "private-subnet-2b"
  }
}

# Create database subnet in second AZ
resource "aws_subnet" "db_subnet_2" {
  vpc_id     = aws_vpc.goji.id
  cidr_block = "10.0.6.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"
  tags = {
    Name = "db-subnet-2b"
  }
}

#Create Pubiic RT
resource "aws_route_table" "goji-public-rt" {
  vpc_id = aws_vpc.goji.id
  
  route {
      //associated subnet can reach everywhere
      cidr_block = "0.0.0.0/0" 
      //RT uses this IGW to reach internet
      gateway_id = aws_internet_gateway.goji-igw.id
  }
  tags = {
      Name = "goji-public-rt"
 }
}

resource "aws_route_table_association" "goji-rta-public-subnet-1a"{
  subnet_id = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.goji-public-rt.id
}

resource "aws_route_table_association" "goji-rta-public-subnet-1b"{
  subnet_id = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.goji-public-rt.id
}


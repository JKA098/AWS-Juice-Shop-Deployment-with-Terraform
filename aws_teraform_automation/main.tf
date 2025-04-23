provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "juice_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "juice-vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.juice_vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"
  tags = {
    Name = "public-subnet-test"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.juice_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "private-subnet-test"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.juice_vpc.id
  tags = {
    Name = "juice-igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.juice_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "public-rt"
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_eip" "nat_eip" {
  vpc = true
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id
  tags = {
    Name = "juice-nat-gw"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.juice_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    Name = "private-rt"
  }
}

resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_key_pair" "juice_key" {
  key_name   = "tech-one-ec2-key"
  public_key = file("~/.ssh/tech-one-ec2-key.pub")
}

resource "aws_instance" "bastion" {
  ami           = "ami-0c02fb55956c7d316" # Ubuntu 20.04 in us-east-1
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet.id
  key_name      = aws_key_pair.juice_key.key_name
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]

  tags = {
    Name = "juice-bastion"
  }
}

resource "aws_instance" "private_app" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private

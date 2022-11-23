resource "aws_vpc" "development-vpc" {
  enable_dns_hostnames = true
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "${var.organisation}-vpc"
  }
}

resource "aws_subnet" "dev-subnet-1" {
  vpc_id = aws_vpc.development-vpc.id
  cidr_block = var.subnet_cidr_block
  availability_zone = "us-west-2a"
  tags = {
    Name = "${var.organisation}-subnet"
  }
}

resource "aws_default_security_group" "myapp-sg" {
  vpc_id = aws_vpc.development-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    prefix_list_ids = []
  }

  tags = {
    Name = "${var.organisation}-security-group"
  }
}

resource "aws_internet_gateway" "myapp-igw" {
  vpc_id = aws_vpc.development-vpc.id

  tags = {
    Name = "${var.organisation}-internet-gateway"
  }
}
resource "aws_default_route_table" "main-rtb" {
  default_route_table_id = aws_vpc.development-vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp-igw.id
  }
  tags = {
    Name = "${var.organisation}-main-rtb"
  }
}

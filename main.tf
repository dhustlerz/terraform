provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc" "development-vpc" {
  enable_dns_hostnames = true
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Jashan-vpc"
  }
}

resource "aws_subnet" "dev-subnet-1" {
  vpc_id = aws_vpc.development-vpc.id
  cidr_block = var.subnet_cidr_block
  availability_zone = "us-west-2a"
  tags = {
    Name = "ibt-subnet"
  }
}


data "aws_ami" "ubuntu" {

  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}


resource "aws_key_pair" "ssh-key" {
  key_name   = "myapp-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCZGC1LhnM5Iwwr57kXfCahqaFmaqXKgAPhCm0L6iD0nJ4Kvqnzjhkhf8mRD0XENcgPwZHnkSphvmeHR8NrsmtHNJQsW2j0qg7hTH8bevtqF3E7pXBJficRx78XCzmbXmOvoXRUbmHeZ+ArWVAiyIR9T9x9qd+fJYVupAuyy3tUtlmR8iUrhLUjFPktzJq37ZnhH6S1toos8se08Q8BCY6n1ZnU36sCvUqogC7G/mB12p8vfBmDuEaeyEsyY0pQx/5nM52f1jlWGznd4zOjbljuXiCtzg8q1/MZvTId/HpLa7yZA4/x8uDA93/jJHPgdhmAD3Bg1F2ne77/GmXfp04j9SN3nT6XL2GLyGneCtr5L981/+kv/ySfJ/TmhGoJZCHka5Q9bhyrnNDKXp5VK/XAUEQnMhWTx8TQw4E0V293E0TETFVn9yPw11jeOnyk2UCOKzcq+6/0HypLephkcxZ8bAlvkPmPy25Sb8Ve3c8/2O6kilMChiWYQ9CgBBFqm9U= jashanpreetpahwa@jashanpreetpahwa"
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
    Name = "dev-ibt-security-group"
  }
}

resource "aws_internet_gateway" "myapp-igw" {
  vpc_id = aws_vpc.development-vpc.id

  tags = {
    Name = "dev-ibt-internet-gateway"
  }
}
resource "aws_default_route_table" "main-rtb" {
  default_route_table_id = aws_vpc.development-vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp-igw.id
  }
  tags = {
    Name = "ibt-main-rtb"
  }
}


resource "aws_instance" "myapp-server" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.ssh-key.key_name
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.dev-subnet-1.id
  vpc_security_group_ids      = [aws_default_security_group.myapp-sg.id]
#  availability_zone = "us-east-1a"

  tags = {
    Name = "dev-ibt-server"
  }
}




output "server-ip" {
  value = aws_instance.myapp-server.public_ip
}
output "aws" {
  value = aws_default_security_group.myapp-sg.id
}

provider "aws" {
  region = "us-east-1"
  access_key = "AKIAZFSH2TVGVD775HFW"
  secret_key = "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"
}

resource "aws_vpc" "development-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Jashan-vpc"
  }
}

resource "aws_subnet" "dev-subnet-1" {
  vpc_id = aws_vpc.development-vpc.id
#  cidr_block = "10.0.10.0/24"
  cidr_block = var.subnet_cidr_block
  availability_zone = "us-east-1a"
  tags = {
    Name = "Jashan-subnet"
  }
}

data "aws_vpc" "vpc_data" {
  default = true
}

resource "aws_subnet" "dev-subnet-2" {
  vpc_id = data.aws_vpc.vpc_data.id
  cidr_block = "172.31.128.0/20"
  availability_zone = "us-east-1f"
  tags = {
    Name = "Jashan-subnet"
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
  public_key = var.ssh_key
}


resource "aws_instance" "myapp-server" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.ssh-key.key_name
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.myapp-subnet-1.id
  vpc_security_group_ids      = [aws_default_security_group.myapp-sg.id]
  availability_zone			  = var.avail_zone

  tags = {
    Name = "${var.env_prefix}-server"
  }
}

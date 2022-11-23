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
  key_name   = "${var.environment}-${var.organisation}-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCZGC1LhnM5Iwwr57kXfCahqaFmaqXKgAPhCm0L6iD0nJ4Kvqnzjhkhf8mRD0XENcgPwZHnkSphvmeHR8NrsmtHNJQsW2j0qg7hTH8bevtqF3E7pXBJficRx78XCzmbXmOvoXRUbmHeZ+ArWVAiyIR9T9x9qd+fJYVupAuyy3tUtlmR8iUrhLUjFPktzJq37ZnhH6S1toos8se08Q8BCY6n1ZnU36sCvUqogC7G/mB12p8vfBmDuEaeyEsyY0pQx/5nM52f1jlWGznd4zOjbljuXiCtzg8q1/MZvTId/HpLa7yZA4/x8uDA93/jJHPgdhmAD3Bg1F2ne77/GmXfp04j9SN3nT6XL2GLyGneCtr5L981/+kv/ySfJ/TmhGoJZCHka5Q9bhyrnNDKXp5VK/XAUEQnMhWTx8TQw4E0V293E0TETFVn9yPw11jeOnyk2UCOKzcq+6/0HypLephkcxZ8bAlvkPmPy25Sb8Ve3c8/2O6kilMChiWYQ9CgBBFqm9U= jashanpreetpahwa@jashanpreetpahwa"
}

resource "aws_instance" "this" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.ssh-key.key_name
  associate_public_ip_address = true
  subnet_id                   = var.subnet-id
  vpc_security_group_ids      = [var.sg-id]
  #  availability_zone = "us-east-1a"

  tags = {
    Name = "${var.environment}-${var.organisation}-server"
  }
}

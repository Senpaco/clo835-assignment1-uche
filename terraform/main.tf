provider "aws" {
  region = "us-east-1"  # Change to your region
}

resource "aws_ecr_repository" "web" {
  name = "clo835-web-repo"
}

resource "aws_ecr_repository" "mysql" {
  name = "clo835-mysql-repo"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_security_group" "instance_sg" {
  name        = "clo835-sg"
  description = "Allow SSH and app ports"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8081
    to_port     = 8083
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  ami           = "ami-026992d753d5622bc"  # Replace with latest Amazon Linux 2 AMI (find via AWS Console → EC2 → AMIs, filter "amazon/amzn2-ami-hvm")
  instance_type = "t2.micro"
  subnet_id     = data.aws_subnets.public.ids[0]  # First public subnet
  vpc_security_group_ids = [aws_security_group.instance_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "clo835-instance"
  }
}
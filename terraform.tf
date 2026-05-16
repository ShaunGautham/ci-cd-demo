terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.45"
    }
  }
}

provider "aws" {
  region = "as-southeast-1"
}

resource "aws_vpc" "ci-cd-demo" {
    cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.ci-cd-demo.id

  tags = {
    Name = "ci-cd-demo-gateway"
  }
}

resource "aws_subnet" "ci-cd-demo-subnet" {
  vpc_id            = aws_vpc.ci-cd-demo.id
  cidr_block        = "10.0.1.0/24"
}

resource "aws_route_table" "ci-cd-demo-route-table" {
  vpc_id = aws_vpc.ci-cd-demo.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "ci-cd-demo-route-table-association" {
  subnet_id      = aws_subnet.ci-cd-demo-subnet.id
  route_table_id = aws_route_table.ci-cd-demo-route-table.id
}

resource "aws_security_group" "ci-cd-demo-sg" {
  name        = "ci-cd-demo-sg"
  description = "Allow SSH and HTTP traffic"
  vpc_id      = aws_vpc.ci-cd-demo.id

  ingress {
    description = "allow ssh traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "allow http traffic"
    from_port   = 80
    to_port     = 80
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

resource "aws_eip" "demo-eip" { 
    instance = aws_instance.ci-cd-demo.id
}

resource "aws_key_pair" "demo-key" {
  key_name   = "ci-cd-demo-key"
  public_key = file("~/.ssh/ci-cd-demo.pub")
  
}

resource "aws_instance" "ci-cd-demo" {
  ami           = "ami-02dd44faa40720bb8"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.ci-cd-demo-sg.id]
  subnet_id = aws_subnet.ci-cd-demo-subnet.id
  key_name = aws_key_pair.demo-key.key_name

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install docker -y
              service docker start
              usermod -aG docker ec2-user
              chkconfig docker on
              EOF

  tags = {
    Name = "ci-cd-demo-instance"
  }
}

output "ec2_public_ip" {
  value = aws_eip.demo-eip.public_ip
}

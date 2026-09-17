# EC2 in default VPC — mirrors Console lab 02

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

# SSH key pair — saves .pem locally (gitignored)
resource "tls_private_key" "lab" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "lab" {
  key_name   = "${local.name_prefix}-key"
  public_key = tls_private_key.lab.public_key_openssh
}

resource "local_file" "private_key" {
  content         = tls_private_key.lab.private_key_pem
  filename        = "${path.module}/${local.name_prefix}-key.pem"
  file_permission = "0400"
}

resource "aws_security_group" "web" {
  name        = "${local.name_prefix}-sg"
  description = "SSH and HTTP from student IP only"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH from My IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  ingress {
    description = "HTTP for nginx test"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [local.http_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.lab.key_name
  vpc_security_group_ids = [aws_security_group.web.id]
  subnet_id              = data.aws_subnets.default.ids[0]

  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              dnf install -y nginx
              systemctl start nginx
              systemctl enable nginx
              echo "<h1>Terraform EC2 Lab — ${var.student_name}</h1>" > /usr/share/nginx/html/index.html
              EOF

  tags = {
    Name = "${local.name_prefix}-web"
  }
}

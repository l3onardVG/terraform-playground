# Data source to fetch the latest Amazon Linux 2 AMI (Free Tier eligible)
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  # Ensure we get a free tier eligible AMI (Amazon Linux 2)
  filter {
    name   = "description"
    values = ["*Amazon Linux 2*"]
  }
}

resource "aws_key_pair" "key" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

resource "aws_instance" "server" {
  ami                         = data.aws_ami.amazon_linux_2.id
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnet_id
  key_name                    = aws_key_pair.key.key_name
  associate_public_ip_address = true
  security_groups             = [var.security_group_id]
      tags = {
    Name = "public_server"
  }
}
resource "aws_instance" "server_2" {
  ami                         = data.aws_ami.amazon_linux_2.id
  instance_type               = var.instance_type
  subnet_id                   = var.private_subnet_id
  key_name                    = aws_key_pair.key.key_name
  associate_public_ip_address = true
  security_groups             = [var.security_group_id]

    tags = {
    Name = "private_server"
  }

}
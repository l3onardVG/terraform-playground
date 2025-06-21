# Data source to fetch the latest Amazon Linux 2023 AMI (Free Tier eligible) - uses dnf
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
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

  # Ensure we get Amazon Linux 2023 which uses dnf
  filter {
    name   = "description"
    values = ["*Amazon Linux 2023*"]
  }
}

resource "aws_key_pair" "key" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

resource "aws_instance" "server" {
  ami                         = data.aws_ami.amazon_linux_2023.id
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnet_id
  key_name                    = aws_key_pair.key.key_name
  associate_public_ip_address = true
  security_groups             = [var.security_group_id]
  
  # Configuración de almacenamiento EBS
  root_block_device {
    volume_size = 20  # 20 GB en lugar del default de 8 GB
    volume_type = "gp3"
    encrypted   = true
    
    tags = {
      Name = "public_server_root_volume"
    }
  }
  
  user_data = <<EOF
#!/bin/bash
echo "Actualizando el sistema"
sudo dnf update -y
echo "Instalando git"
sudo dnf install -y git
echo "Instalando dotnet"
sudo dnf install -y dotnet-sdk-8.0
echo "Instalando nodejs"
sudo dnf install -y nodejs
EOF

  user_data_replace_on_change = true

      tags = {
    Name = "public_server"
  }
}
resource "aws_instance" "server_2" {
  ami                         = data.aws_ami.amazon_linux_2023.id
  instance_type               = var.instance_type
  subnet_id                   = var.private_subnet_id
  key_name                    = aws_key_pair.key.key_name
  associate_public_ip_address = true
  security_groups             = [var.security_group_id]

    tags = {
    Name = "private_server"
  }

}
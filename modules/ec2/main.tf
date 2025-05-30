resource "aws_key_pair" "key" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

resource "aws_instance" "server" {
  ami                         = var.ami
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
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.private_subnet_id
  key_name                    = aws_key_pair.key.key_name
  associate_public_ip_address = true
  security_groups             = [var.security_group_id]

    tags = {
    Name = "private_server"
  }

}
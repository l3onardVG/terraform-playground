provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "my_vpc" {
   cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id
}

resource "aws_subnet" "public" {
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = "10.0.2.0/24"
    availability_zone = var.aws_sub_region
    map_public_ip_on_launch = true
}

resource "aws_subnet" "private" {
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = var.aws_sub_region
}

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.my_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
}

resource "aws_route_table_association" "public_assoc" {
    subnet_id = aws_subnet.public.id
    route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "ssh_icmp_sg" {
    name = "ssh_icmp_sg"
    description = "Allow SSH and ICMP trafic"
    vpc_id = aws_vpc.my_vpc.id

    ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Be cautious! This allows SSH from anywhere
  }

  ingress {
    description = "Allow ICMP (Ping)"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "server" {
    ami = var.instance_ami
    instance_type = var.instance_type
    subnet_id = aws_subnet.public.id
    associate_public_ip_address = true
    security_groups = [aws_security_group.ssh_icmp_sg.id]
}
resource "aws_internet_gateway" "this" {
  vpc_id = var.vpc_id
}

resource "aws_subnet" "public" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.public_cidr
  availability_zone       = var.az
  map_public_ip_on_launch = true
  tags = { Name = "pub-subnet" }
}

resource "aws_subnet" "private" {
  vpc_id            = var.vpc_id
  cidr_block        = var.private_cidr
  availability_zone = var.az
  tags = { Name = "private-subnet" }
}

resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}
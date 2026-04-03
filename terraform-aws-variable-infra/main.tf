resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${local.name_prefix}-vpc"
  }
}

resource "aws_subnet" "main" {
  cidr_block              = var.subnet_cidr
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "${local.name_prefix}-subnet"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-server"
  })
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.route_table
    gateway_id = aws_internet_gateway.gw.id
  }
}


resource "aws_route_table_association" "rta" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}


resource "aws_security_group" "main" {
  vpc_id = aws_vpc.main.id

  ingress {
    description = "Allow SSH"
    from_port   = var.allowed_ports[0]
    to_port     = var.allowed_ports[0]
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP"
    from_port   = var.allowed_ports[1]
    to_port     = var.allowed_ports[1]
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-server"
  })
}

resource "aws_instance" "my_terraweek_instance" {
  ami                         = data.aws_ami.amazon_linux_2.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.main.id
  vpc_security_group_ids      = [aws_security_group.main.id]
  associate_public_ip_address = true

  tags = {
    Name = "${local.name_prefix}-server"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_s3_bucket" "my_aws_bucket" {
  depends_on = [aws_instance.my_terraweek_instance]
  bucket     = "terraweek-ashu-s3-bucket2"
}

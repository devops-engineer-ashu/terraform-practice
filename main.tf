resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "TerraWeek-VPC"
  }
}

resource "aws_subnet " "main" {
  cidr_block = "10.0.1.0/24"
  vpc_id = aws_vpc.main.id
  map_public_ip_on_launch = true
  tags = {
    Name = "Main"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}


resource "aws_route_table_association" "rta" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}


resource "aws_security_group" "main" {
   vpc_id      = aws_vpc.main.id  

    ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   ingress {
    description = "Allow HTTP"
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

  tags = {
    Name = "TerraWeek-SG"
  }
}

resource "aws_instance" "my-instance" {
  ami           = "ami-0735c191cf9147540"
  instance_type = "t2.micro"
  vpc_security_group_ids = aws_security_group.main.id
  associate_public_ip_address = true

  tags = {
    Name = "TerraWeek-Server"
  }
  lifecycle {
  create_before_destroy = true
}
}

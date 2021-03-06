resource "aws_vpc" "myvpc" {
  cidr_block       = var.vpc_cidr
  

  tags = {
    Name = "myvpc"
  }
}


resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "My_IGW"
  }
}


resource "aws_subnet" "mysubnet" {

  count = length(var.subnet_cidr)
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = element(var.subnet_cidr, count.index)
  availability_zone = element(var.azs, count.index)
  tags = {
    Name = "Subnet-${count.index + 1}"
  }
}



resource "aws_route_table" "my_RT" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "myRT"
  }
}


resource "aws_route_table_association" "subnet_ass_to_RT" {
  count = length(var.subnet_cidr)
  subnet_id      = element(aws_subnet.mysubnet.*.id, count.index)
  route_table_id = aws_route_table.my_RT.id
}
resource "aws_vpc" "myvpc" {
    cidr_block = "90.90.0.0/16"
    tags = {
      Name = "MYVPC"
    }
}
resource "aws_subnet" "public" {
    vpc_id     = aws_vpc.myvpc.id
    cidr_block = "90.90.1.0/24"
    tags = {
      Name = "Public"
    }
  
}
resource "aws_subnet" "private" {
    vpc_id     = aws_vpc.myvpc.id
    cidr_block = "90.90.2.0/24"
    tags = {
      Name = "Private"
    }
}
resource "aws_internet_gateway" "gw" {
    vpc_id = aws_vpc.myvpc.id
    tags = {
      Name = "MYIGW"
    }
  
}
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.myvpc.id
  
}
resource "aws_route_table_association" "public" {
    subnet_id      = aws_subnet.public.id
    route_table_id = aws_route_table.public.id
  
}
resource "aws_route" "public" {
    route_table_id         = aws_route_table.public.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id             = aws_internet_gateway.gw.id

}
resource "aws_eip" "myeip" {
    domain = "vpc"
  tags = {
    Name = "MyEIP"
  }
}
resource "aws_nat_gateway" "mynat" {
    allocation_id = aws_eip.myeip.id
    subnet_id     = aws_subnet.public.id
    tags = {
      Name = "MyNAT"
    }
}
resource "aws_route_table" "private" {
    vpc_id = aws_vpc.myvpc.id
    tags = {
      name = "private"
    }
  
}
resource "aws_route_table_association" "private" {
    subnet_id      = aws_subnet.private.id
    route_table_id = aws_route_table.private.id
  
}
resource "aws_route" "private" {
    route_table_id         = aws_route_table.private.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id         = aws_nat_gateway.mynat.id

}
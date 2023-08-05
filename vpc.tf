provider "aws" {
  region  = var.region
}

 resource "aws_instance" "demo-server" {
  ami           = var.os-name
  instance_type = var.instance-type
  key_name       = var.key
  associate_public_ip_address = true
  subnet_id = aws_subnet.demo_subnet-1.id
  vpc_security_group_ids = [aws_security_group.demo-vpc-sg.id]

 }
resource "aws_subnet" "demo_subnet-2" {
  vpc_id     = "${aws_vpc.demo.id}"
  cidr_block = var.subnet2-cidr
  availability_zone = var.subnet-az-2
  map_public_ip_on_launch = "true"


  tags = {
    Name = "demo_subnet-2"
  }
}
 //create a VPC
 resource "aws_vpc" "demo" {
   cidr_block = var.vpc-cidr
 }
//create a 1ST subnet
resource "aws_subnet" "demo_subnet-1" {
  vpc_id     = "${aws_vpc.demo.id}"
  cidr_block = var.subnet1-cidr
  availability_zone = var.subnet-az-1
  map_public_ip_on_launch = "true"

  tags = {
    Name = "demo_subnet-1"
  }
}

//create a internet gateway
resource "aws_internet_gateway" "demo-igw" {
  vpc_id = "${aws_vpc.demo.id}"

  tags = {
    Name = "demo-internetgateway"
  }
}
// creat a route table

resource "aws_route_table" "demo-rt" {
  vpc_id = "${aws_vpc.demo.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.demo-igw.id}"
  }
  tags={
    name = "demo-rt"
  }
}
//associate subnet1 with routtable
resource "aws_route_table_association" "demo-rt_association-1" {
  subnet_id      = "${aws_subnet.demo_subnet-1.id}"
  route_table_id = aws_route_table.demo-rt.id
}
//associate subnet2 with routtable
resource "aws_route_table_association" "demo-rt_association-2" {
  subnet_id      = "${aws_subnet.demo_subnet-2.id}"
  route_table_id = aws_route_table.demo-rt.id
}
//security group
resource "aws_security_group" "demo-vpc-sg" {
  name        = "demo-vpc-sg"
  vpc_id      = aws_vpc.demo.id

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}
module "sgs"{
    source ="./sg_eks"
    vpc_id = aws_vpc.demo.id
}
module "eks"{
    source="./EKS"
    sg_ids= module.sgs.security_group_public
    vpc_id= aws_vpc.demo.id
    subnet_ids =[aws_subnet.demo_subnet-1.id,aws_subnet.demo_subnet-2.id]
}
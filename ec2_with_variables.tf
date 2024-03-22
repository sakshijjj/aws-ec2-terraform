provider "aws" {
  region = var.region
}

resource "aws_instance" "myec2" {
    ami = var.ami
    instance_type = var.instance_type
    key_name = "Tokyo"
    subnet_id    ="${aws_subnet.demo-subnet.id}" 
    vpc_security_group_ids  = [aws_security_group.demo-sg.id]
}
// VPC 
resource "aws_vpc" "demo-vpc" {
  cidr_block = var.vpc_cidr
   tags = {
      Name = "demo-vpc"
    }
}
//Subnets 
resource "aws_subnet" "demo-subnet" {
  vpc_id     = "${aws_vpc.demo-vpc.id}"
  cidr_block = var.subnet_cidr
  map_public_ip_on_launch = "true"
  tags = {
    Name = "demo-subnet"
  }
}

// internet-gatway
resource "aws_internet_gateway" "demo-igw" {
  vpc_id =  "${aws_vpc.demo-vpc.id}"

  tags = {
    Name = "demo-igw"
  }
}
// route-table
resource "aws_route_table" "demo-rt" {
  vpc_id =  "${aws_vpc.demo-vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.demo-igw.id}"
  }

  tags = {
    Name = "demo-rt"
  }
}

// associate subnet with route table 
resource "aws_route_table_association" "demo-rt-asso" {
  subnet_id      = "${aws_subnet.demo-subnet.id}"
  route_table_id = "${aws_route_table.demo-rt.id}"
}

// security group 

resource "aws_security_group" "demo-sg" {
  name        = "demo-sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = "${aws_vpc.demo-vpc.id}"

  tags = {
    Name = "demo-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ingress-sg" {
  security_group_id = "${aws_security_group.demo-sg.id}"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}


resource "aws_vpc_security_group_egress_rule" "egree-sg" {
  security_group_id = "${aws_security_group.demo-sg.id}"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

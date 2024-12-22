#CreateResourceinaws
resource "aws_vpc" "vpc"{
    cidr_block= var.vpc_cidr
    
    tags = {
        Name = var.vpc_name
    }
    }

resource "aws_subnet" "sub1"{
    vpc_id = aws_vpc.vpc.id
    cidr_block= var.s1
    availability_zone = "ap-south-1a"
    map_public_ip_on_launch = true
    tags = {
        Name=var.sub_name
    }
    }

resource "aws_subnet" "sub2"{
    vpc_id = aws_vpc.vpc.id
    cidr_block= var.s2
    availability_zone = "ap-south-1b"
     map_public_ip_on_launch = true
    tags={
        Name=var.sub_name1
    }
}
resource "aws_internet_gateway" "igw"{
    vpc_id = aws_vpc.vpc.id
    tags={
        Name="igw"
    }
}
resource "aws_route_table" "rtb1"{
    vpc_id = aws_vpc.vpc.id
    
    route{
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id

    }
}
resource "aws_route_table_association""rta"{
    subnet_id = aws_subnet.sub1.id
    route_table_id = aws_route_table.rtb1.id
}
resource "aws_route_table_association""rta2"{
    subnet_id = aws_subnet.sub2.id
    route_table_id = aws_route_table.rtb1.id
}
resource "aws_security_group" "sgw" {
    name   = "websg"
    vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = "sgw"
  }
}

resource "aws_vpc_security_group_ingress_rule""ing1" {
  security_group_id = aws_security_group.sgw.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}
resource "aws_vpc_security_group_ingress_rule""ing2" {
  security_group_id = aws_security_group.sgw.id
   
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}
resource "aws_vpc_security_group_egress_rule" "out1" {
  security_group_id = aws_security_group.sgw.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
resource "aws_instance" "ama1" {
  ami                     = "ami-0fd05997b4dff7aac"
  instance_type           = "t2.nano"
  
  vpc_security_group_ids = [aws_security_group.sgw.id]
  subnet_id = aws_subnet.sub1.id
}
provider "aws" {
  region = var.location
}

resource "aws_instance" "eks-instance" {
  ami                         = var.ami-id
  key_name                    = var.key
  instance_type               = var.instance-type
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.eks-subnet-01.id
  vpc_security_group_ids      = [aws_security_group.eks-vpc-sg.id]

  tags = {
    Name = "eks_instance"
  }

}

resource "aws_vpc" "eks-vpc" {
  cidr_block = var.vpc-cidr

  tags = {
    Name = "eks_vpc"
  }

}


resource "aws_subnet" "eks-subnet-01" {
  vpc_id            = aws_vpc.eks-vpc.id
  cidr_block        = var.subnet-01-cidr
  availability_zone = var.subnet_az-01
  map_public_ip_on_launch = "true"

  tags = {
    Name = "eks_subnet-01"
  }
}

resource "aws_subnet" "eks-subnet-02" {
  vpc_id            = aws_vpc.eks-vpc.id
  cidr_block        = var.subnet-02-cidr
  availability_zone = var.subnet_az-02
  map_public_ip_on_launch = "true"

  tags = {
    Name = "eks_subnet-02"
  }
}



resource "aws_internet_gateway" "eks-igw" {
  vpc_id = aws_vpc.eks-vpc.id

  tags = {
    Name = "eks_igw"
  }
}

resource "aws_route_table" "eks-route-table" {
  vpc_id = aws_vpc.eks-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks-igw.id
  }
  tags = {
    Name = "eks_route_table"
  }
}

resource "aws_route_table_association" "eks-route-table-association-01" {
  subnet_id = aws_subnet.eks-subnet-01.id

  route_table_id = aws_route_table.eks-route-table.id
}

resource "aws_route_table_association" "eks-route-table-association-02" {
  subnet_id = aws_subnet.eks-subnet-02.id

  route_table_id = aws_route_table.eks-route-table.id
}


resource "aws_security_group" "eks-vpc-sg" {
  name = "eks-vpc-sg"

  vpc_id = aws_vpc.eks-vpc.id

  ingress {

    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {

    from_port        = 5000
    to_port          = 5000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {

    from_port        = 30000
    to_port          = 30000
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
    Name = "eks_vpc_sg"
  }
}


module "security_groups" {

  source = "./sg_eks"
  vpc_id = aws_vpc.eks-vpc.id

}

module "eks" {
  source     = "./eks"
  sg_ids     = module.security_groups.security_group_public
  vpc_id     = aws_vpc.eks-vpc.id
  subnet_ids = [aws_subnet.eks-subnet-01.id, aws_subnet.eks-subnet-02.id]
}

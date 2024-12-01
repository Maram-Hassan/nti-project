resource "aws_vpc" "vpc" {
    cidr_block = var.vpc_cidr
    tags = {
        Name = "vpc"
    }
  
}
resource "aws_subnet" "pub1_subnet" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.pub_subnet[0]
    availability_zone = var.az[0]
    map_public_ip_on_launch = true
}

resource "aws_subnet" "pub2_subnet" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.pub_subnet[1]
    availability_zone = var.az[1]
    map_public_ip_on_launch = true
}

resource "aws_subnet" "priv1_subnet" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.priv_subnet[0]
    availability_zone = var.az[0]
}

resource "aws_subnet" "priv2_subnet" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.priv_subnet[1]
    availability_zone = var.az[1] 
}

resource "aws_internet_gateway" "IGW" {
    vpc_id = aws_vpc.vpc.id
    tags = {
        Name = "IGW"
    }
}

# resource "aws_route_table" "vpc_route" {
#     vpc_id = aws_vpc.vpc.id
#     route {
#         cidr_block = "0.0.0.0/0"
#         gateway_id = aws_internet_gateway.IGW.id
#     }
  
# }

# resource "aws_route_table_association" "IGW_association" {
#     subnet_id = [aws_subnet.pub1_subnet.id, aws_subnet.pub2_subnet.id]
#     route_table_id = aws_internet_gateway.IGW.id
# }



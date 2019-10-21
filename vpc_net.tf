resource "aws_vpc" "web_vpc"{
cidr_block = "10.0.0.0/16"
tags = {
Name = "Web_VPC"
}
}

resource "aws_subnet" "Public1" {
cidr_block = "10.0.0.0/26"
vpc_id = "${aws_vpc.web_vpc.id}"
#availbility_zone = "us-west-2a"
tags = {
Name = "public-subnet-web"
}
}

resource "aws_subnet" "private" {
cidr_block = "10.0.0.64/26"
vpc_id = "${aws_vpc.web_vpc.id}"
tags = {
Name = "private-subnet-web"
}
}

resource "aws_internet_gateway" "web-gw" {
vpc_id = "${aws_vpc.web_vpc.id}"
tags = {
Name = "Web_IGW"
}
}
resource "aws_eip" "nat-eip" {
vpc = true
tags = { 
Name = "Nat-EIP"
}
}

resource "aws_nat_gateway" "Web_nat" {
allocation_id = "${aws_eip.nat-eip.id}"
subnet_id = "${aws_subnet.Public1.id}"
tags = {
Name = "web-nat-gateway"
}
}

resource "aws_route_table" "public" {
vpc_id = "${aws_vpc.web_vpc.id}"
route {
cidr_block = "0.0.0.0/0"
gateway_id = "${aws_internet_gateway.web-gw.id}"
}
tags = {
Name = "web-public-rt"
}
}

resource "aws_route_table" "private" {
vpc_id = "${aws_vpc.web_vpc.id}"
route {
cidr_block = "0.0.0.0/0"
nat_gateway_id = "${aws_nat_gateway.Web_nat.id}"
}
tags = {
Name = "web-private-rt"
}
}

resource "aws_route_table_association" "private" {
subnet_id = "${aws_subnet.private.id}"
route_table_id = "${aws_route_table.private.id}"
}

resource "aws_route_table_association" "public" {
subnet_id = "${aws_subnet.Public1.id}"
route_table_id = "${aws_route_table.public.id}"
}
resource "aws_main_route_table_association" "main" {
vpc_id = "${aws_vpc.web_vpc.id}"
route_table_id = "${aws_route_table.public.id}"
} 

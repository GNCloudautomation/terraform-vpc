output "VPC" {
value = ["${aws_vpc.web_vpc.id}"]
}

output "web_Public-aws_subnet" {
value = ["${aws_subnet.Public1.id}"]
}

output "nat" {
value = ["${aws_nat_gateway.Web_nat.id}"]
}

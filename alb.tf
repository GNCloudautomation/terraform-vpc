resource "aws_lb_target_group" "web" {
name = "Web-alb"
port = 80
protocol = "http"
target_type = "instance"
vpc_id = "${aws_vpc.web_vpc.id}"
}

resource "aws_vpc" "main" {
  cidr_block = "${var.vpc_cidr}"
}

resource "aws_subnet" "main" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "${var.subnet_cidr}"
}

resource "aws_security_group" "onos_tutorial" {
  name        = "onos-tutorial"
  description = "Allow traffic for ONOS tutorial"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port   = 8181
    to_port     = 8183
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8101
    to_port     = 8103
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 2375
    to_port     = 2375
    protocol   = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
     from_port = 0
     to_port = 0
     protocol = "-1"
     cidr_blocks = ["0.0.0.0/0"]
   }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.main.id}"
}

resource "aws_route_table" "route" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = "${aws_subnet.main.id}"
  route_table_id = "${aws_route_table.route.id}"
}

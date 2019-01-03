resource "aws_internet_gateway" "consul_internet_gateway" {
  vpc_id = "${aws_vpc.consul_vpc.id}"

  tags {
    Name = "consul_igw"
  }
}

resource "aws_eip" "nat_eip" {
  vpc = true

  tags = {
    Name = "consul_nat_elasticip"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = "${aws_eip.nat_eip.id}"
  subnet_id     = "${aws_subnet.consul_privateB_subnet.id}"
  depends_on    = ["aws_internet_gateway.consul_internet_gateway"]

  tags = {
    Name = "consul_nat"
  }
}

resource "aws_route_table" "consul_public_route" {
  vpc_id = "${aws_vpc.consul_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.consul_internet_gateway.id}"
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = "${aws_internet_gateway.consul_internet_gateway.id}"
  }

  tags = {
    Name = "consul_public_route"
  }
}

resource "aws_route_table" "consul_private_route" {
  vpc_id = "${aws_vpc.consul_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.nat.id}"
  }

  tags = {
    Name = "consul_private_route"
  }
}

resource "aws_route_table_association" "publicA" {
  subnet_id      = "${aws_subnet.consul_publicA_subnet.id}"
  route_table_id = "${aws_route_table.consul_public_route.id}"
}

resource "aws_route_table_association" "privateA" {
  subnet_id      = "${aws_subnet.consul_privateA_subnet.id}"
  route_table_id = "${aws_route_table.consul_private_route.id}"
}

resource "aws_route_table_association" "publicB" {
  subnet_id      = "${aws_subnet.consul_publicB_subnet.id}"
  route_table_id = "${aws_route_table.consul_public_route.id}"
}

resource "aws_route_table_association" "privateB" {
  subnet_id      = "${aws_subnet.consul_privateB_subnet.id}"
  route_table_id = "${aws_route_table.consul_private_route.id}"
}

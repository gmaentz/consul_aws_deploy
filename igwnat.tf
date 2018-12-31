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

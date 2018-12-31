#-------------AWS Region-----------

#-------------VPC-----------
resource "aws_vpc" "consul_vpc" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags {
    Name = "consul_vpc"
  }
}

#--------Avaialability Zones----
data "aws_availability_zones" "available" {}

#-------------Subnets-----------
resource "aws_subnet" "consul_publicA_subnet" {
  vpc_id                  = "${aws_vpc.consul_vpc.id}"
  cidr_block              = "${var.cidrs["publicA"]}"
  map_public_ip_on_launch = true
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name = "PublicA"
  }
}

resource "aws_subnet" "consul_publicB_subnet" {
  vpc_id                  = "${aws_vpc.consul_vpc.id}"
  cidr_block              = "${var.cidrs["publicB"]}"
  map_public_ip_on_launch = true
  availability_zone       = "${data.aws_availability_zones.available.names[1]}"

  tags {
    Name = "PublicB"
  }
}

resource "aws_subnet" "consul_privateA_subnet" {
  vpc_id                  = "${aws_vpc.consul_vpc.id}"
  cidr_block              = "${var.cidrs["privateA"]}"
  map_public_ip_on_launch = false
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name = "PrivateA"
  }
}

resource "aws_subnet" "consul_privateB_subnet" {
  vpc_id                  = "${aws_vpc.consul_vpc.id}"
  cidr_block              = "${var.cidrs["privateB"]}"
  map_public_ip_on_launch = false
  availability_zone       = "${data.aws_availability_zones.available.names[1]}"

  tags {
    Name = "PrivateB"
  }
}

#load balancer

resource "aws_elb" "consul_ui_elb" {
  name = "consul-ui-elb"

  subnets = ["${aws_subnet.consul_publicA_subnet.id}",
    "${aws_subnet.consul_publicB_subnet.id}",
  ]

  security_groups = ["${aws_security_group.consul_ui_sg.id}"]

  listener {
    instance_port     = 8500
    instance_protocol = "http"
    lb_port           = 8500
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = "2"
    unhealthy_threshold = "10"
    timeout             = "5"
    target              = "TCP:8500"
    interval            = "30"
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags {
    Name = "consul_ui_access-elb"
  }
}

resource "aws_security_group" "consul_ui_sg" {
  name        = "consul_ui_sg"
  description = "Used for public access to consul UI via load balancer"
  vpc_id      = "${aws_vpc.consul_vpc.id}"

  #HTTP 

  ingress {
    from_port   = 8500
    to_port     = 8500
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #Outbound internet access

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

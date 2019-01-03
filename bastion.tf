### Pull Latest Amazon AMI ###
data "aws_ami" "ec2-linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
}

resource "aws_instance" "bastion_server" {
  instance_type = "${var.bastion_instance_type}"
  ami           = "${data.aws_ami.ec2-linux.id}"

  tags {
    Name = "bastion_server"
  }

  key_name                    = "${var.bastion_key_name}"
  vpc_security_group_ids      = ["${aws_security_group.bastion_sg.id}"]
  subnet_id                   = "${aws_subnet.consul_publicB_subnet.id}"
  associate_public_ip_address = "true"

  provisioner "remote-exec" {
    inline = ["sudo yum update -y"]
  }
}

### Security Group ####
resource "aws_security_group" "bastion_sg" {
  name        = "bastion_sg"
  description = "Used for access to the bastion host"
  vpc_id      = "${aws_vpc.consul_vpc.id}"

  #SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.localip}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

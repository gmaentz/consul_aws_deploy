# Create a new Consul Cluster
module "consul_cluster" {
  # TODO: update this to the final URL
  # Use version v0.0.5 of the consul-cluster module
  # Alternatively you can clone the repo below and reference it as a file
  source = "github.com/hashicorp/terraform-aws-consul//modules/consul-cluster?ref=v0.0.5"

  vpc_id       = "${aws_vpc.consul_vpc.id}"
  cluster_name = "consul-test"

  # Specify the ID of the Consul AMI. You should build this using the scripts in the install-consul module.
  ami_id        = "${var.consul_ami}"
  instance_type = "${var.consul_instance_type}"

  # Add this tag to each node in the cluster
  cluster_tag_key   = "consul-cluster"
  cluster_tag_value = "consul-cluster-example"

  # Configure and start Consul during boot. It will automatically form a cluster with all nodes that have that same tag.
  user_data = <<-EOF
              #!/bin/bash
              /opt/consul/bin/run-consul --server --cluster-tag-key consul-cluster
              EOF

  allowed_inbound_cidr_blocks = ["${var.cidrs["privateA"]}",
    "${var.cidrs["privateB"]}",
  ]

  cluster_size                   = 3
  subnet_ids                     = ["${aws_subnet.consul_privateA_subnet.id}", "${aws_subnet.consul_privateB_subnet.id}"]
  ssh_key_name                   = "${var.bastion_key_name}"
  # allowed_ssh_security_group_ids = ["${aws_security_group.bastion_sg.id}"]
  associate_public_ip_address    = "true"
  # enable_iam_setup               = true
}

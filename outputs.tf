output "bastion_id" {
  value = "${aws_instance.bastion_server.public_ip}"
}

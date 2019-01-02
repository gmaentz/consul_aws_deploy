variable "aws_region" {
  description = "The AWS region that infrastructure will be deployed to."
}

variable "vpc_cidr" {
  description = "The ID of the VPC in which the nodes will be deployed."
}

variable "cidrs" {
  description = "CIDR Blocks of Private and Public subnets to be created"
  type        = "map"
}

variable "bastion_ami" {
  description = "AMI with Consul Binaries installed"
}

variable "bastion_instance_type" {
  description = "EC2 Instance Type"
}

variable "localip" {
  description = "Local IP address to limit access to bastion host"
}

variable "bastion_key_name" {
  description = "key to use for connecting to bastion host"
}

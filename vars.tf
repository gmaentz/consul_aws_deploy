variable "aws_region" {
    description = "The AWS region that infrastructure will be deployed to."

}
variable "vpc_cidr" {
      description = "The ID of the VPC in which the nodes will be deployed."
}

variable "cidrs" {
  description = "CIDR Blocks of Private and Public subnets to be created"
  type = "map"
}
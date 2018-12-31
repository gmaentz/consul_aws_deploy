# consul_aws_deploy
Deploying Consul Servers to AWS using AutoScaling Groups

## Automating the install of HashiCorp Consul in AWS.
Pulling from several sources to do this.

1. Use Packer to Build the Consul Server AMI
2. Utilize an AWS AutoScaling Group to deploy the AMI, with tags to run and create a cluster
3. Deploy Changes using Terraform Enterprise

# consul_aws_deploy
Deploying Consul Servers to AWS using AutoScaling Groups

## Automating the install of HashiCorp Consul in AWS.
Pulling from several sources to do this.

1. Use Packer to Build the Consul Server AMI
2. Utilize an AWS AutoScaling Group to deploy the AMI, with tags to run and create a cluster
3. Deploy Changes using Terraform Enterprise

## Steps

Each Module has the following folder structure:

* [Examples on Blog](http://www.maentz.net/)
* [Install Consul](http://www.maentz.net/)
* [consul-cluster](https://github.com/hashicorp/terraform-aws-consul/tree/master/modules/consul-cluster) 
  module to deploy a [Consul](https://www.consul.io/) cluster in [AWS](https://aws.amazon.com/).
* [modules](https://github.com/hashicorp/terraform-aws-consul/tree/master/modules): This folder contains the reusable code for this Module, broken down into one or more modules.
* [test](https://github.com/hashicorp/terraform-aws-consul/tree/master/test): Automated tests for the modules and examples.

To deploy Consul servers using this Module:

1. Create a Consul AMI using a Packer template that references the [install-consul module](https://github.com/hashicorp/terraform-aws-consul/tree/master/modules/install-consul).
   Here is an [example Packer template](https://github.com/hashicorp/terraform-aws-consul/tree/master/examples/consul-ami#quick-start). 
   
1. Deploy that AMI across an Auto Scaling Group using the Terraform [consul-cluster module](https://github.com/hashicorp/terraform-aws-consul/tree/master/modules/consul-cluster) 
   and execute the [run-consul script](https://github.com/hashicorp/terraform-aws-consul/tree/master/modules/run-consul) with the `--server` flag during boot on each 
   Instance in the Auto Scaling Group to form the Consul cluster. Here is [an example Terraform 
   configuration](https://github.com/hashicorp/terraform-aws-consul/tree/master/examples/root-example#quick-start) to provision a Consul cluster.

To deploy Consul clients using this Module:
 
1. Use the [install-consul module](https://github.com/hashicorp/terraform-aws-consul/tree/master/modules/install-consul) to install Consul alongside your application code.
1. Before booting your app, execute the [run-consul script](https://github.com/hashicorp/terraform-aws-consul/tree/master/modules/run-consul) with `--client` flag.
1. Your app can now using the local Consul agent for service discovery and key/value storage. 
1. Optionally, you can use the [install-dnsmasq module](https://github.com/hashicorp/terraform-aws-consul/tree/master/modules/install-dnsmasq) to configure Consul as the DNS for a
   specific domain (e.g. `.consul`) so that URLs such as `foo.service.consul` resolve automatically to the IP 
   address(es) for a service `foo` registered in Consul (all other domain names will be continue to resolve using the
   default resolver on the OS).
   
 
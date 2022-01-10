variable "force_new_launch_config" {
  description = <<DESC
Set to true to force a name change on the Autoscaling Launch Configuration.
This may be needed if the ASG failed to create (failed health checks) and is tainted.
When this occurs, terraform wants to drop and recreate the ASG. Because the ASG uses
the launch configuration name as it's name, and the LC didn't change, that causes
terraform to try to create the new ASG using the same name as the old ASG, which fails.
Setting this variable to 'true' will force the name of the LC to change, so the
new ASG will also have a unique name.
DESC

  type = bool
  default = false
}

variable "context" {
}

variable "environment" {
}

variable "instance_type" {
}

variable "server_name" {
  type = string
  default = "squidproxy"
}

variable "internal_dns_zone_id" {
  description = "ID of the Route53 hosted zone in which DNS records should be placed"
}

variable "instances_per_region" {
  type = number
  default = 2
  description = "Number of EC2 instances to create in each region"
}

variable "private_subnets" {
  type = list(string)
}

variable "instance_profile_name" {
}

variable "vpc_id" {
}

variable "ec2_instance_count" {
  type = number
  description = "Number of EC2 instances to create in this region"
}

variable "vpc_cidr_blocks" {
  type = list(string)
}

variable "common_ec2_access_sg" {
}

variable "region-short-name-map" {
  type = map(string)

  default = {
    "us-east-1" = "awse"
    "us-east-2" = "awse"
    "us-west-1" = "awsw"
    "us-west-2" = "awsw"
  }
}

variable "non_prod_ami_owner" {
  default = "443212964806"
}

variable "squidproxy-release" {

}
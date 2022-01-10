data "aws_caller_identity" "current" {
}

data "aws_region" "current" {}

data "aws_ami" "centos7" {
  most_recent = true

  filter {
    name   = "tag:Runner"
    values = ["packer"]
  }
  filter {
    name   = "tag:OS_Version"
    values = ["CentOS7"]
  }

  filter {
    name   = "tag:Playbooks"
    values = ["RHEL7-CIS"]
  }

  owners = [var.environment == "dev" || var.environment == "int" ? var.non_prod_ami_owner : data.aws_caller_identity.current.account_id]
}

data "template_file" "user-data" {
  template = file("${path.module}/templates/user-data.tpl")
  vars = {
    environment = var.environment
    squidproxy-release = var.squidproxy-release
  }
}
module "proxy-asg-east" {
  source                    = "./modules/asg"
  environment               = var.environment
  context                   = var.context
  squidproxy-release        = data.aws_ssm_parameter.squidproxy-version.value
  instance_type             = var.instance_type
  ec2_instance_count        = var.instances_per_region
  vpc_id                        = data.terraform_remote_state.lucholab0-shared-services.outputs.vpc_id_east
  private_subnets               = [data.terraform_remote_state.lucholab0-shared-services.outputs.private_subnet_1_east, data.terraform_remote_state.lucholab0-shared-services.outputs.private_subnet_2_east]
  instance_profile_name         = aws_iam_instance_profile.squidproxy_profile.name
  common_ec2_access_sg          = data.terraform_remote_state.lucholab0-shared-services.outputs.common_ec2_access_sg_id_east
  internal_dns_zone_id          = var.internal_dns_zone_id

  vpc_cidr_blocks = [
    data.terraform_remote_state.lucholab0-shared-services.outputs.vpc_cidr_east,
    data.terraform_remote_state.lucholab0-shared-services.outputs.vpc_cidr_west
  ]

  force_new_launch_config   = var.force_new_launch_config
  providers = {
    aws = aws.east
  }
}

module "proxy-asg-west" {
  source                    = "./modules/asg"
  environment               = var.environment
  context                   = var.context
  squidproxy-release        = data.aws_ssm_parameter.squidproxy-version.value
  instance_type             = var.instance_type
  ec2_instance_count        = var.instances_per_region
  vpc_id                        = data.terraform_remote_state.lucholab0-shared-services.outputs.vpc_id_west
  private_subnets               = [data.terraform_remote_state.lucholab0-shared-services.outputs.private_subnet_1_west, data.terraform_remote_state.lucholab0-shared-services.outputs.private_subnet_2_west]
  instance_profile_name         = aws_iam_instance_profile.squidproxy_profile.name
  common_ec2_access_sg          = data.terraform_remote_state.lucholab0-shared-services.outputs.common_ec2_access_sg_id_west
  internal_dns_zone_id          = var.internal_dns_zone_id

  vpc_cidr_blocks = [
    data.terraform_remote_state.lucholab0-shared-services.outputs.vpc_cidr_east,
    data.terraform_remote_state.lucholab0-shared-services.outputs.vpc_cidr_west
  ]

  force_new_launch_config   = var.force_new_launch_config
  providers = {
    aws = aws.west
  }
}
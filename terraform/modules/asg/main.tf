
locals {
  asg_instance_name = "${var.environment}-${local.region_short_name}-${var.context}-asg"
}

resource "aws_launch_configuration" "lc" {
  name_prefix     = "lc-${var.context}-${local.region_short_name}-${var.squidproxy-release}-${var.force_new_launch_config ? substr(uuid(),9,5) : "" }"
  image_id        = data.aws_ami.centos7.id
  instance_type   = var.instance_type
  security_groups = [var.common_ec2_access_sg, aws_security_group.squidproxy.id]
  user_data       = data.template_file.user-data.rendered
  enable_monitoring = true

  # Minimize downtime by creating a new launch config before destroying old one
  lifecycle {
    create_before_destroy = true
  }

  iam_instance_profile = var.instance_profile_name

}

resource "aws_autoscaling_group" "asg" {
  name                 = "asg-${var.context}-${local.region_short_name}-${aws_launch_configuration.lc.id}"
  max_size             = var.ec2_instance_count + 4
  min_size             = var.ec2_instance_count
  desired_capacity     = var.ec2_instance_count
  health_check_grace_period = 480
  health_check_type = "ELB"
  launch_configuration = aws_launch_configuration.lc.name
  min_elb_capacity     = 1
  vpc_zone_identifier  = var.private_subnets
  target_group_arns    = [ aws_lb_target_group.tg-postfix.arn, aws_lb_target_group.tg-squid.arn ]
  enabled_metrics      = [ "GroupMinSize","GroupMaxSize","GroupDesiredCapacity","GroupInServiceInstances","GroupPendingInstances","GroupStandbyInstances","GroupTerminatingInstances","GroupTotalInstances"]

  wait_for_capacity_timeout = "8m"

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = local.asg_instance_name
    propagate_at_launch = true
  }

  tag {
    key                 = "Role"
    value               = "squidproxy"
    propagate_at_launch = true
  }
  tag {
    key                 = "PCIDSS"
    value               = "1.3.5"
    propagate_at_launch = true
  }
}
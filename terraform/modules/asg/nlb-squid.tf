resource "aws_lb" "nlb-squid" {
  name               = "${var.environment}-${var.context}-nlb"
  provider           = aws
  internal           = true
  load_balancer_type = "network"
  subnets            = var.private_subnets

  tags = {
    Name    = "${var.environment}-${var.context}-nlb"
    PCIDSS  = "1.3.5"
    Context = "${var.environment}-${var.context}"
    Role    = "squidproxy"
  }
}

resource "aws_lb_target_group" "tg-squid" {
  name     = "${var.environment}-${var.context}-squid-tg"
  provider = aws
  port     = 3128
  protocol = "TCP"
  vpc_id   = var.vpc_id
  health_check {
    protocol            = "TCP"
    interval            = 30
    port                = 3128
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group" "tg-postfix" {
  name     = "${var.environment}-${var.context}-postfix-tg"
  provider = aws
  port     = 25
  protocol = "TCP"
  vpc_id   = var.vpc_id
  health_check {
    protocol            = "TCP"
    interval            = 30
    port                = 25
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "lb-listener-squid" {
  provider          = aws
  load_balancer_arn = aws_lb.nlb-squid.arn
  port              = 3128
  protocol          = "TCP"

  default_action {
    target_group_arn = aws_lb_target_group.tg-squid.arn
    type             = "forward"
  }
}

resource "aws_lb_listener" "lb-listener-postfix" {
  provider          = aws
  load_balancer_arn = aws_lb.nlb-squid.arn
  port              = 25
  protocol          = "TCP"

  default_action {
    target_group_arn = aws_lb_target_group.tg-postfix.arn
    type             = "forward"
  }
}

resource "aws_route53_record" "nlb-dns-alias" {
  name    = "${var.context}-${local.region_direction_name}"
  type    = "A"
  zone_id = var.internal_dns_zone_id
  alias {
    evaluate_target_health = false
    name                   = aws_lb.nlb-squid.dns_name
    zone_id                = aws_lb.nlb-squid.zone_id
  }
}


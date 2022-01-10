resource "aws_security_group" "squidproxy" {
  name   = "${var.environment}-${var.context}-asg-sg"
  vpc_id = var.vpc_id
  tags = {
    Name    = "${var.environment}-${var.context}-sg"
    PCIDSS  = "2.2"
    Context = "${var.environment}-${var.context}"
  }
  # no egress or ingress is defined and no rules should exist
}

resource "aws_security_group_rule" "allow_squid_inbound" {
  type              = "ingress"
  from_port         = 3128
  to_port           = 3128
  protocol          = "tcp"
  cidr_blocks       = var.vpc_cidr_blocks
  security_group_id = aws_security_group.squidproxy.id
  description       = "Allows squid inbound"
}

resource "aws_security_group_rule" "allow_smtp_inbound" {
  type              = "ingress"
  from_port         = 25
  to_port           = 25
  protocol          = "tcp"
  cidr_blocks       = var.vpc_cidr_blocks
  security_group_id = aws_security_group.squidproxy.id
  description       = "Allows smtp inbound"
}

resource "aws_security_group_rule" "allow_squid_outbound_22" {
  type              = "egress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.squidproxy.id
  description       = "Allows squid outbound for SSH/SFTP"
}

resource "aws_security_group_rule" "allow_squid_outbound_80" {
  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.squidproxy.id
  description       = "Allows squid outbound for HTTP"
}

resource "aws_security_group_rule" "allow_squid_outbound_443" {
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.squidproxy.id
  description       = "Allows squid outbound for HTTPS"
}

resource "aws_security_group_rule" "allow_proxy_outbound_587" {
  type              = "egress"
  from_port         = 587
  to_port           = 587
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.squidproxy.id
  description       = "Allows smtps outbound"
}


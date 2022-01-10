data "aws_iam_policy_document" "instance-assume-role-policy-document" {
  provider = aws.east

  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "instance-role-policy-document" {
  provider = aws.east

  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "ec2:AttachVolume",
      "ec2:DescribeVolumeStatus",
      "ec2:DescribeVolumes",
      "ec2:DescribeInstances",
      "ec2:DescribeTags",
    ]

    resources = ["*"]
  }

  statement {
    actions = ["ssm:GetParameter*"]
    effect  = "Allow"
    resources = [
      "arn:aws:ssm:us-east-1:${data.aws_caller_identity.current.account_id}:parameter/sesproxy/*",
      "arn:aws:ssm:us-west-1:${data.aws_caller_identity.current.account_id}:parameter/sesproxy/*",
    ]
  }
}

resource "aws_iam_role_policy" "instance-role-policy" {
  provider = aws.east
  name     = "${var.environment}-${var.context}-instance-policy"
  role     = aws_iam_role.instance-role.id
  policy   = data.aws_iam_policy_document.instance-role-policy-document.json
}

resource "aws_iam_role" "instance-role" {
  provider           = aws.east
  name               = "${var.environment}-${var.context}-instance-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.instance-assume-role-policy-document.json
}

resource "aws_iam_role_policy_attachment" "instance_role_attachment-ssm" {
  provider   = aws.east
  role       = aws_iam_role.instance-role.name
  policy_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/${var.environment}-lucholab0-ec2-role-for-ssm-policy"
}

resource "aws_iam_role_policy_attachment" "instance_role_attachment-common" {
  provider   = aws.east
  role       = aws_iam_role.instance-role.name
  policy_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/${var.environment}-lucholab0-ec2-role-common-policy"
}

resource "aws_iam_instance_profile" "squidproxy_profile" {
  provider = aws.east
  name     = "${var.environment}-${var.context}-instance-profile"
  role     = aws_iam_role.instance-role.name
}


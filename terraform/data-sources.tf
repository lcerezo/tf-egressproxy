data "aws_caller_identity" "current" {
  provider = aws.east
}

data "aws_ssm_parameter" "squidproxy-version" {
  name = "/lucholab0-squidproxy/version"
  with_decryption = "true"
  provider = aws.east
}

data "terraform_remote_state" "lucholab0-shared-services" {
  backend = "s3"

  config = {
    bucket = "lucholab0-terraform-state-${var.environment}"
    key    = "terraform-states/${var.shared-services-state-key}/terraform.tfstate"
    region = "us-east-1"
  }
}
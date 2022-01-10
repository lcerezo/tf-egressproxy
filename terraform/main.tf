# -----------------------------------------------------------------------------
# squidproxy configuration
#
# This configuration provides a full implementation of all the available
# site modules and is suitable for a complete production deployment.
# -----------------------------------------------------------------------------

terraform {
  required_version = ">= 0.13"
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  alias  = "east"
  region = "us-east-1"
}

provider "aws" {
  alias  = "west"
  region = "us-west-1"
}

/*

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

#Backend remote state configuration

terraform {
  backend "s3" {
    bucket = "malkosergeyseconddemoecs"
    region = "eu-central-1"
    key    = "staging/codebuild/terraform.tfstate"
  }
}
*/

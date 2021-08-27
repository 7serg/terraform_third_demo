variable "aws_region" {

  default = "eu-central-1"
}

variable "bucket_name" {
  type    = string
  default = "malkosergeyseconddemoecs"
}

variable "aws_profile" {
  default = "default"
}


variable "vpc_id" {
  type        = string
  default     = null
  description = "The VPC ID for CodeBuild"
}

variable "app_name" {
  type    = string
  default = "test-nginx"
}

variable "env" {
  default = "dev"
}

variable "build_spec_file" {
  description = "Path to the buldspecfile"
  default     = "buildspec.yml"

}

variable "repo_url" {
  description = "Url of the GitHub repository"
  default     = "https://github.com/7serg/webtest"

}



variable "subnets" {
  default     = null
  description = "The subnet IDs that include resources used by CodeBuild"
}


variable "branch_pattern" {
  default = "main"
}

variable "git_trigger_event" {
  default = "PUSH"
}

variable "github_oauth_token" {
  description = "Github OAuth token with repo access permissions"
}

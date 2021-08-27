data "terraform_remote_state" "infrastructure" {
  backend = "s3"
  config = {
    bucket = var.bucket_name
    key    = "staging/infrastructure/terraform.tfstate"
    region = var.aws_region
  }
}



data "aws_region" "curent" {}



resource "aws_security_group" "codebuild_sg" {
  name        = "allow_vpc_connectivity"
  description = "Allow Codebuild connectivity to all the resources within our VPC"

  #should be changed to the following vpc_id = var.vpc_id in order to call from module
  vpc_id = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "null_resource" "import_source_credentials" {


  triggers = {
    github_oauth_token = var.github_oauth_token
  }

  provisioner "local-exec" {
    command = <<EOF
      aws --region ${data.aws_region.current.name} codebuild import-source-credentials \
                                                             --token ${var.github_oauth_token} \
                                                             --server-type GITHUB \
                                                             --auth-type PERSONAL_ACCESS_TOKEN
EOF
  }
}



resource "aws_codebuild_project" "my_app" {
  depends_on    = [null_resource.import_source_credentials]
  name          = "${var.app_name}-${var.env}"
  description   = "Codebuild for deploying our application"
  build_timeout = "120"
  #role has not been created yet
  service_role = aws_iam_role.codebuild.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL" #3GB Memory according to the AWS specification
    image        = "aws/codebuild/standard:4.0"
    type         = "LINUX_CONTAINER"
    #Whether to enable running the Docker daemon inside a Docker container.
    privileged_mode = true

    environment_variable {
      name  = "CI"
      value = true
    }

  }
  logs_config {
    cloudwatch_logs {
      group_name  = "${var.app_name}-${var.env}-log-group"
      stream_name = "${var.app_name}-${var.env}-log-stream"
    }
  }


  source {
    buildspec           = var.build_spec_file
    type                = "GITHUB"
    location            = var.repo_url
    git_clone_depth     = 1
    report_build_status = "true"
  }

  vpc_config {
    vpc_id = var.vpc_id

    subnets = var.subnets

    security_group_ids = [aws_security_group.codebuild_sg.id]
  }
}

resource "aws_codebuild_webhook" "develop_webhook" {
  project_name = aws_codebuild_project.my_app.name

  # https://docs.aws.amazon.com/codebuild/latest/APIReference/API_WebhookFilter.html
  filter_group {
    filter {
      type    = "EVENT"
      pattern = var.git_trigger_event
    }

    filter {
      type    = "HEAD_REF"
      pattern = var.branch_pattern
    }
  }
}

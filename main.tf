provider "aws" {
  region = "eu-central-1"
}


module "ecs_cluster" {
  source = "./modules/ecs_cluster"

  #aws_region       = var.aws_region
  #  profile          = var.aws_profile

  bucket_name        = var.bucket_name
  env                = var.env
  app_name           = var.app_name
  app_count          = var.app_count
  ecr_repository_url = var.ecr_repository_url
  image_tag          = var.image_tag
  taskdef_template   = "./modules/ecs_cluster/taskdef.json"

}


module "codebuild" {
  source             = "./modules/codebuild"
  vpc_id             = module.ecs_cluster.vpc_id
  subnets            = module.ecs_cluster.private_subnet_ids
  github_oauth_token = var.github_oauth_token
  env                = var.env
  app_name           = var.app_name
  repo_url           = var.repo_url
  git_trigger_event  = var.git_trigger_event
  branch_pattern     = var.branch_pattern
  build_spec_file    = var.build_spec_file

}

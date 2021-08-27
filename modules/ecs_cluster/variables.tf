
variable "aws_region" {

  default = "eu-central-1"
}



variable "bucket_name" {
  type    = string
  default = "malkosergeyseconddemoecs"

}

variable "versioning" {
  type    = bool
  default = true
}


variable "tags" {
  type = map(any)
  default = {
    Name        = "demoecs",
    environment = "staging"
  }
}

variable "vpc_cidr" {
  default     = "10.10.0.0/16"
  description = "VPC cidr block"
}

variable "env" {
  default = "dev"
}



variable "public_subnets_cidr" {
  description = "Public subnets"
  default = [
    "10.10.11.0/24",
    "10.10.12.0/24"
  ]

}


variable "private_subnets_cidr" {
  description = "Private subnets cidr"
  default = [
    "10.10.20.0/24",
    "10.10.21.0/24"
  ]
}

variable "bastion_ssh_key_name" {
  default = "test"
}


#ervice variables

variable "app_port" {
  default = 80
}

variable "task_definition_name" {
  type    = string
  default = "nginxtask"
}

variable "ecs_service_name" {
  type    = string
  default = "test"
}
/*
variable "docker_image_url" {
  type    = string
  default = "182009040698.dkr.ecr.eu-central-1.amazonaws.com/nginx-test:latest"
}
*/

variable "fargate_cpu" {
  default = "256"
}

variable "fargate_memory" {
  default = "512"
}

variable "image_tag" {
  type    = string
  default = "latest"

}

variable "taskdef_template" {
  default = "taskdef.json"
}


variable "ecr_repository_url" {
  type    = string
  default = "182009040698.dkr.ecr.eu-central-1.amazonaws.com/nginx-test"
}

#defines how many tasks to run
variable "app_count" {
  default = 2

}

variable "app_name" {
  type    = string
  default = "test-nginx"
}

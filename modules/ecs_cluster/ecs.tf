resource "aws_ecs_cluster" "app_cluster" {
  name = "${var.app_name}-${var.env}-ECS-Cluster"

}


data "template_file" "ecs_task_definition_template" {
  template = file(var.taskdef_template)

  vars = {
    #task_definition_name = "${var.app_name}-${var.env}-task"    #var.ecs_service_name
    app_name           = var.app_name
    env                = var.env
    ecs_service_name   = "${var.app_name}-${var.env}-service" #var.ecs_service_name
    image_tag          = var.image_tag
    ecr_repository_url = var.ecr_repository_url
    memory             = var.fargate_memory
    cpu                = var.fargate_cpu
    region             = var.aws_region
    app_port           = var.app_port


  }
}

resource "aws_ecs_task_definition" "app" {
  container_definitions    = data.template_file.ecs_task_definition_template.rendered
  family                   = "${var.app_name}-${var.env}-task"
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.fargate_iam_role.arn
  task_role_arn            = aws_iam_role.ecs_cluster_role.arn

}


resource "aws_ecs_service" "ecs_service" {
  name            = "${var.app_name}-${var.env}-service"
  cluster         = aws_ecs_cluster.app_cluster.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"
  task_definition = aws_ecs_task_definition.app.arn

  network_configuration {
    subnets          = aws_subnet.private_subnets[*].id
    security_groups  = [aws_security_group.app_security_group.id]
    assign_public_ip = true

  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_cluster_alb.arn
    container_name   = "${var.app_name}-${var.env}-app"
    container_port   = var.app_port
  }

  depends_on = [aws_ecs_task_definition.app, aws_lb_listener.ecs_cluster_alb, aws_iam_role_policy.fargate_iam_role_policy]


}

resource "aws_cloudwatch_log_group" "app_log_group" {
  name = "${var.app_name}-${var.env}-LogGroup"

}

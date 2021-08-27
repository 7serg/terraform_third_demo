
#Initialization of application load balancer

resource "aws_lb" "ecs_cluster_alb" {
  name            = "${var.env}-${var.app_name}-LB"
  subnets         = aws_subnet.public_subnets[*].id
  security_groups = [aws_security_group.alb.id]
  internal        = false
  depends_on      = [aws_subnet.public_subnets]
}


resource "aws_lb_target_group" "ecs_cluster_alb" {
  name        = "${var.env}-${var.app_name}-ALB-TG"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.demoecs_vpc.id
  target_type = "ip"
  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/"
    unhealthy_threshold = "2"
  }

}
/*
resource "aws_lb_target_group_attachment" "webservers" {
  count            = length(aws_instance.web_server[*].id)
  target_group_arn = aws_lb_target_group.ecs_cluster_alb.id
  target_id        = element(aws_instance.web_server[*].id, count.index)
  port             = 80
}
*/


resource "aws_lb_listener" "ecs_cluster_alb" {
  load_balancer_arn = aws_lb.ecs_cluster_alb.id
  port              = var.app_port
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.ecs_cluster_alb.id
    type             = "forward"
  }
  depends_on = [aws_lb_target_group.ecs_cluster_alb]
}

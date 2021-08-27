#Security group for load balancer

resource "aws_security_group" "alb" {
  name = "${var.env}-${var.app_name}-lb_sg"

  description = "controls connection to alb"
  vpc_id      = aws_vpc.demoecs_vpc.id

  dynamic "ingress" {
    for_each = ["80", "443"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {
    Name = "load-balancer-sg"
  }
}

resource "aws_security_group" "bastion" {
  name = "${var.env}-${var.app_name}-bastion_sg"

  description = "controll connections from bastion servers"
  vpc_id      = aws_vpc.demoecs_vpc.id


  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.private_subnets_cidr

  }

  tags = {
    Name = "bastion-sg"
  }
}


resource "aws_security_group" "webserver" {

  description = "controls access to web-servers"
  vpc_id      = aws_vpc.demoecs_vpc.id

  /*  dynamic "ingress" {
    for_each = ["80", "443"]
    content {
      from_port       = ingress.value
      to_port         = ingress.value
      protocol        = "tcp"
      security_groups = ["aws_security_group.alb.id"]
    }
  }
*/
  ingress {
    protocol        = "tcp"
    from_port       = 443
    to_port         = 443
    security_groups = [aws_security_group.alb.id]
  }

  ingress {
    protocol        = "tcp"
    from_port       = 80
    to_port         = 80
    security_groups = [aws_security_group.alb.id]
  }


  ingress {
    protocol        = "tcp"
    from_port       = 22
    to_port         = 22
    security_groups = [aws_security_group.bastion.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {
    Name = "${var.env}-${var.app_name}-webservers_sg"
  }
}


#Security group ecs service
resource "aws_security_group" "app_security_group" {
  name        = "${var.ecs_service_name}-${var.env}-${var.app_name}-SG"
  description = "Security group for our application"
  vpc_id      = aws_vpc.demoecs_vpc.id

  ingress {
    from_port       = var.app_port
    to_port         = var.app_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
  depends_on = [aws_security_group.alb]
}

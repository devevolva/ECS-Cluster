###############################################################################
# 
# ALB
#
###############################################################################

resource "aws_alb" "alb-ecs-web" {
  name               = "alb-ecs-web"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg-alb-ecs-web.id]
  subnets            = aws_subnet.subnet-main[*].id

  tags = {
    Name = "alb-ecs-web"
  }
}

resource "aws_alb_listener" "alb-ecs-web-listener" {
  load_balancer_arn = aws_alb.alb-ecs-web.arn
  port              = "80"
  protocol          = "HTTP"


  default_action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.tg-alb-ecs-web.arn}"
  }
}


resource "aws_alb_target_group" "tg-alb-ecs-web" {
  name     = "tg-alb-ecs-web"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

#   health_check {
#     healthy_threshold   = 2
#     interval            = 15
#     path                = "/wp-admin/install.php"
#     timeout             = 10
#     unhealthy_threshold = 2
#   }
}


# ALB Security Group:: sg-alb-ecs-web
resource "aws_security_group" "sg-alb-ecs-web" {
  vpc_id = aws_vpc.main.id
  name   = "alb-ecs-web"

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
}
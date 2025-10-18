# alb
resource "aws_lb" "alb" {
  name                       = "application-load-balancer"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [var.lb_sg]
  subnets                    = var.public_subnets_id
  enable_deletion_protection = false
}

# listener app
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

resource "aws_lb_listener_rule" "jenkins_rule" {
  listener_arn = aws_lb_listener.http_listener.arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jenkins_tg.arn
  }

  condition {
    path_pattern {
      values = ["/jenkins/*"]
    }
  }
}

# # listener jenkins master
# resource "aws_lb_listener" "jenkins_listener" {
#   load_balancer_arn = aws_lb.alb.arn
#   port              = "8080"
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.jenkins_tg.arn
#   }
# }

#Target group for app
resource "aws_lb_target_group" "app_tg" {
  name     = "app-tg"
  port     = 5000
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    path                = "/"
    healthy_threshold   = 3
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }
}

#Target group for jenkins master
resource "aws_lb_target_group" "jenkins_tg" {
  name     = "jenkins-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    path                = "/"
    healthy_threshold   = 3
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }
}

#Target group attachment app
resource "aws_lb_target_group_attachment" "app_tg_attach" {
  count            = length(var.app_instance)
  target_group_arn = aws_lb_target_group.app_tg.arn
  target_id        = var.app_instance[count.index]
  port             = 5000
}

#Target group attachment jenkins
resource "aws_lb_target_group_attachment" "jenkins_tg_attach" {
  count            = length(var.jenkins_master)
  target_group_arn = aws_lb_target_group.jenkins_tg.arn
  target_id        = var.jenkins_master[count.index]
  port             = 80
}

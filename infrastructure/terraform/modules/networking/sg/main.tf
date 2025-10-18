# jenkins sg
resource "aws_security_group" "jenkins" {
  name        = "jenkins-sg"
  description = "Sg for jenkins server"
  vpc_id      = var.vpc_id
  tags = {
    "Name" = "${var.deployment_prefix}-jenkins-sg"
  }
}

# jenkins workers sg
resource "aws_security_group" "jenkins_workers" {
  name        = "jenkins-worker-sg"
  description = "sg for jenkins workers"
  vpc_id      = var.vpc_id
  tags = {
    "Name" = "${var.deployment_prefix}-jenkins-worker-sg"
  }
}

# app sg
resource "aws_security_group" "app" {
  name        = "app-sg"
  description = "sg for app"
  vpc_id      = var.vpc_id
  tags = {
    "Name" = "${var.deployment_prefix}-app-sg"
  }
}

# load balancer sg
resource "aws_security_group" "load_balancer" {
  name        = "load-balancer-sg"
  description = "sg for load balancer"
  vpc_id      = var.vpc_id
  tags = {
    "Name" = "${var.deployment_prefix}-load-balancer-sg"
  }
}

# rds sg
resource "aws_security_group" "rds_msql" {
  name        = "rds-mysql-sg"
  description = "sg for rds mysql"
  vpc_id      = var.vpc_id
  tags = {
    "Name" = "${var.deployment_prefix}-rds-mysql-sg"
  }
}

# allow all trafic to loadbalancer from internet on 80 port
resource "aws_security_group_rule" "ingress_traffic_to_lb_80" {
  description       = "allow traffic to lb"
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.load_balancer.id
}

# allow traffic to app from lb
resource "aws_security_group_rule" "egress_traffic_to_lb_5000" {
  description              = "allow traffic to app from lb"
  type                     = "egress"
  from_port                = 5000
  to_port                  = 5000
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.app.id
  security_group_id        = aws_security_group.load_balancer.id
}

# allow traffic to app from lb
resource "aws_security_group_rule" "ingress_traffic_to_app_5000" {
  description              = "allow traffic to app from lb"
  type                     = "ingress"
  from_port                = 5000
  to_port                  = 5000
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.load_balancer.id
  security_group_id        = aws_security_group.app.id
}


# allow traffic to app from lb
resource "aws_security_group_rule" "egress_traffic_to_lb_80" {
  description              = "allow traffic to jenkins from lb"
  type                     = "egress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.jenkins.id
  security_group_id        = aws_security_group.load_balancer.id
}

# allow traffic to jenkins on port 8080 
resource "aws_security_group_rule" "ingress_jenkins_80_lb" {
  description              = "allow traffic to jenkins"
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.load_balancer.id
  security_group_id        = aws_security_group.jenkins.id
}

# allow traffic to app on port 5000 
resource "aws_security_group_rule" "ingress_app_5000_lb" {
  description       = "allow egress trafic of app into internet"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.app.id
}

# allow traffic to jenkins from jenkins workers on port 8080 
resource "aws_security_group_rule" "ingress_jenkins_8080_workers" {
  description              = "allow traffic to jenkins from jenkins worker (jnlp)"
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.jenkins_workers.id
  security_group_id        = aws_security_group.jenkins.id
}

# allow jenkins traffic to the internet
resource "aws_security_group_rule" "egress_jenkins" {
  description       = "allow egress trafic of jenkins into internet"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.jenkins.id
}

# allow ingress traffic from app into db
resource "aws_security_group_rule" "ingress_db" {
  description              = "allow ingress trafic"
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.app.id
  security_group_id        = aws_security_group.rds_msql.id
}

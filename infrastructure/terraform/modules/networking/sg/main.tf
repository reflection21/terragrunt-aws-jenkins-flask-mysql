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

# sg ingress rule for jenkins server from admin (tcp)
resource "aws_security_group_rule" "ingress_admin" {
  description       = "allow connect admin to jenkins"
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["91.123.151.244/32"]
  security_group_id = aws_security_group.jenkins.id
}

# sg ingress rule for jenkins server from admin (icmp)
resource "aws_security_group_rule" "ingress_admin_icmp" {
  description       = "allow ping jenkins"
  type              = "ingress"
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
  cidr_blocks       = var.jenkins_subnet_cidr
  security_group_id = aws_security_group.jenkins.id
}

# sg ingress rule for jenkins server from jenkins workers
resource "aws_security_group_rule" "ingress_workers" {
  description              = "allow connect workers to jenkins"
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.jenkins_workers.id
  security_group_id        = aws_security_group.jenkins.id
}

# allow internet traffic for jenkins server
resource "aws_security_group_rule" "egress_internet" {
  description       = "allow egress to inet"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.jenkins.id
}

# allow internet traffic for jenkins worker server
resource "aws_security_group_rule" "egress_jnlp_jenkins_workers_from_internet" {
  description       = "allow egress to inet"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.jenkins_workers.id
}

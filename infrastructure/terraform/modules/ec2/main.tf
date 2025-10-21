# jenkins master
resource "aws_instance" "jenkins" {
  count                       = 1
  ami                         = "ami-0a716d3f3b16d290c" # ubuntu 24.04
  instance_type               = "t3.micro"
  subnet_id                   = var.jenkins_subnet[0]
  security_groups             = [var.jenkins_sg]
  monitoring                  = true
  iam_instance_profile        = "jenkins_profile"
  # user_data                   = file("${path.module}/bootstrap_master.sh")
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }
  root_block_device {
    encrypted = true
  }
  tags = {
    "Name"   = "${var.deployment_prefix}-jenkins-server-${count.index + 1}"
    "Ansible" = "${var.deployment_prefix}-jenkins-master"
    "Owner"  = "artembryhynets@gmail.com"
  }
}

# jenkins workers (spot)
resource "aws_spot_instance_request" "jenkins_workers" {
  count                = length(var.jenkins_subnet)
  ami                  = "ami-0a716d3f3b16d290c" 
  instance_type        = "t3.micro"
  subnet_id            = var.jenkins_subnet[count.index]
  security_groups      = [var.jenkins_workers_sg]
  spot_price           = "0.04"
  iam_instance_profile = "jenkins_workers_profile"
  # user_data            = file("${path.module}/bootstrap_workers.sh")

  tags = {
    "Name"   = "${var.deployment_prefix}-jenkins-workers-${count.index + 1}"
    "Ansible" = "${var.deployment_prefix}jenkins-workers"
    "Owner"  = "artembryhynets@gmail.com"
  }
}

# flask servers (on-demand)
resource "aws_instance" "flask_instance" {
  count                       = length(var.app_subnets_id)
  ami                         = "ami-0a716d3f3b16d290c" 
  instance_type               = "t3.micro"
  subnet_id                   = var.app_subnets_id[count.index]
  security_groups             = [var.app_sg]
  monitoring                  = true
  iam_instance_profile        = "app_profile"
  associate_public_ip_address = false
  # user_data                   = file("${path.module}/bootstrap_flask.sh")
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }
  root_block_device {
    encrypted = true
  }
  tags = {
    "Name"   = "${var.deployment_prefix}-flask-server-${count.index + 1}"
    "Ansible" = "${var.deployment_prefix}-flask-servers"
    "Owner"  = "artembryhynets@gmail.com"
  }
}

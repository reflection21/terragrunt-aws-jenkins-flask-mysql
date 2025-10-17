# jenkins master
resource "aws_instance" "jenkins" {
  count                       = length(var.jenkins_subnet)
  ami                         = "ami-0955d1e82085ce3e8"
  instance_type               = "t3.micro"
  subnet_id                   = var.jenkins_subnet[count.index]
  security_groups             = [var.jenkins_sg]
  monitoring                  = true
  iam_instance_profile        = "jenkins_profile"
  associate_public_ip_address = true
  user_data                   = file("${path.module}/bootstrap_master.sh")
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }
  root_block_device {
    encrypted = true
  }
  tags = {
    "Name"   = "${var.deployment_prefix}-jenkins-server-${count.index + 1}"
    "Deploy" = "ansible"
    "Owner"  = "artembryhynets@gmail.com"
  }
}

# jenkins workers (spot)
resource "aws_spot_instance_request" "jenkins_workers" {
  count                = length(var.jenkins_workers_subnet)
  ami                  = "ami-0955d1e82085ce3e8"
  instance_type        = "t3.micro"
  subnet_id            = var.jenkins_workers_subnet[count.index]
  security_groups      = [var.jenkins_workers_sg]
  spot_price           = "0.0036"
  iam_instance_profile = "jenkins_workers_profile"
  user_data            = file("${path.module}/bootstrap_workers.sh")

  tags = {
    "Name"   = "${var.deployment_prefix}-jenkins-workers-${count.index + 1}"
    "Deploy" = "ansible"
    "Owner"  = "artembryhynets@gmail.com"
  }
}

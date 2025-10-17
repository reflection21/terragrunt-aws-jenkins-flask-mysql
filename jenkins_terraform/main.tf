module "networking" {
  source               = "./networking"
  vpc_cidr             = var.vpc_cidr
  cidr_public_subnet   = var.cidr_public_subnet
  cidr_private_subnet  = var.cidr_private_subnet
  eu_availability_zone = var.eu_availability_zone
}

module "security_group" {
  source              = "./security_groups"
  vpc_id              = module.networking.vpc_id
  ec2_sg_name         = "SG for EC2 to enable SSH(22), HTTPS(443) and HTTP(80)"
  ec2_jenkins_sg_name = "Allow port 8080 for jenkins"
}
module "jenkins" {
  source                    = "./jenkins"
  ami_id                    = var.ec2_ami_id
  instance_type             = "t2.micro"
  tag_name                  = "Jenkins:Ubuntu Linux EC2"
  subnet_id                 = tolist(module.networking.subnet_public_id)[0]
  sg_for_jenkins            = [module.security_group.sg_ec2_sg_ssh_http_id, module.security_group.sg_ec2_jenkins_port_8080]
  enable_public_ip_address  = true
  user_data_install_jenkins = templatefile("./jenkins-runner-script/jenkins-installer.sh", {})
  public_key                = var.public_key
}
module "lb_target_group_name" {
  source                   = "./lb_target_group"
  lb_target_group_name     = "jenkins-lb-target-group"
  lb_target_group_port     = 8080
  lb_target_group_protocol = "HTTP"
  vpc_id                   = module.networking.vpc_id
  ec2_instance_id          = module.jenkins.jenkins_ip
}
module "alb" {
  source                          = "./alb"
  lb_name                         = "dev-proj-1-alb"
  is_external                     = false
  lb_type                         = "application"
  sg_enable_ssh_https             = module.security_group.sg_ec2_sg_ssh_http_id
  subnet_ids                      = tolist(module.networking.subnet_public_id)
  lb_target_group_arn             = module.lb_target_group_name.lb_target_group_arn
  ec2_instance_id                 = module.jenkins.jenkins_ip
  lb_target_group_attachment_port = 8080
  lb_listner_port                 = 80
  lb_listner_protocol             = "HTTP"
  lb_listner_default_action       = "forward"
  lb_https_listner_port           = 443
  lb_https_listner_protocol       = "HTTP" #HTTPS
}
module "hosted-zone" {
  source          = "./hosted-zone"
  domain_name     = "jenkins.reflection-21.xyz"
  aws_lb_dns_name = module.alb.aws_lb_dns_name
  aws_lb_zone_id  = module.alb.aws_lb_zone_id
}
/*module "certificate_manager" {
  source         = "./certificate-manager"
  domain_name    = "reflection-21.xyz"
  hosted_zone_id = module.hosted-zone.hosted_zone_id
}*/

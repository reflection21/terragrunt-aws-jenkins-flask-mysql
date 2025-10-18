terraform {
  source = "../../terraform/modules/alb/"
}

include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true # include variables of parents file
}

dependency "vpc" {
  config_path = "../networking/vpc"
}

dependency "sg" {
  config_path = "../networking/sg"
}

dependency "ec2" {
  config_path = "../ec2"
  mock_outputs = {
      ec2_output = "mock-ec2-output"
  }
}

inputs = {
    lb_sg = dependency.sg.outputs.lb_sg
    public_subnets_id = dependency.vpc.outputs.public_subnet_id
    vpc_id = dependency.vpc.outputs.vpc_id
    jenkins_master = dependency.ec2.outputs.jenkins_master
    app_instance = dependency.ec2.outputs.app_instance
}
terraform {
  source = "../../terraform/modules/ec2/"
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

# dependency "iam" {
#   config_path = "../iam"
  
#   mock_outputs = {
#       iam_output = "mock-iam-output"
#       }

# }

inputs = {
  jenkins_subnet = dependency.vpc.outputs.jenkins_subnet_id
  jenkins_sg = dependency.sg.outputs.jenkins_sg
  jenkins_workers_sg = dependency.sg.outputs.jenkins_workers_sg
  app_subnets_id = dependency.vpc.outputs.app_subnets
  app_sg = dependency.sg.outputs.app_sg
}

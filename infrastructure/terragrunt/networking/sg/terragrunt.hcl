terraform {
  source = "../../../terraform/modules/networking/sg/"
}

include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true # include variables of parents file
}

dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
  vpc_id = dependency.vpc.outputs.vpc_id
  jenkins_subnet_cidr = dependency.vpc.outputs.jenkins_subnet_cidr
}



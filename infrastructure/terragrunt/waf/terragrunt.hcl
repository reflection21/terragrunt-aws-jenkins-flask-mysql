terraform {
  source = "../../terraform/modules/waf/"
}

include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true # include variables of parents file
}

dependency "alb" {
  config_path = "../alb"
}

inputs = {
  alb = dependency.alb.outputs.alb_id
}



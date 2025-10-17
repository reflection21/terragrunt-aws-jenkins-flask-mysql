terraform {
  source = "../../../terraform/modules/networking/vpc/"
}


include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true # include variables of parents file
}

inputs = {
    vpc_cidr = "10.10.0.0/16"
    jenkins_subnets_cidr = ["10.10.1.0/24"]
    workers_subnets_cidr = ["10.10.2.0/24"]
    app_subnets_cidr = ["10.10.11.0/24", "10.10.12.0/24"]
    db_subnets_cidr = ["10.10.111.0/24", "10.10.112.0/24"]
}
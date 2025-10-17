variable "deployment_prefix" {
  type    = string
  default = "test"
}

variable "vpc_id" {
  type        = string
  description = "vpc id"
}

variable "jenkins_subnet_cidr" {
  type = list(string)
  description = "jenkins subnet cidr"
}



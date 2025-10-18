variable "deployment_prefix" {
  type    = string
  default = "test"
}

variable "lb_sg" {
  description = "sg for ald"
  type        = string
}

variable "public_subnets_id" {
  description = "public subnet id"
  type        = list(string)
}

variable "vpc_id" {
  description = "vpc id"
  type        = string
}

variable "jenkins_master" {
  description = "jenkins master"
  type        =list(string)
}

variable "app_instance" {
  description = "app instances"
  type        = list(string)
}

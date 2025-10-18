variable "jenkins_subnet" {
  type        = list(string)
  description = "jenkins subnet"
}

variable "jenkins_sg" {
  type        = string
  description = "jenkins sg"
}

variable "deployment_prefix" {
  type    = string
  default = "test"
}

variable "jenkins_workers_sg" {
  type        = string
  description = "jenkins workers sg"
}

variable "app_subnets_id" {
  type        = list(string)
  description = "app subnets id"
}

variable "app_sg" {
  type        = string
  description = "app sg"
}


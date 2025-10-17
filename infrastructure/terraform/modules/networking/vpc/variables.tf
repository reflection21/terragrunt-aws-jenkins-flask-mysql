variable "deployment_prefix" {
  type    = string
  default = "test"
}

variable "vpc_cidr" {
  type        = string
  description = "vpc cidr"
}

variable "jenkins_subnets_cidr" {
  type        = list(string)
  description = "jenkins subnet cidr block"
}

variable "workers_subnets_cidr" {
  type        = list(string)
  description = "workers subnet cidr block"
}

variable "app_subnets_cidr" {
  type        = list(string)
  description = "app subnet cidr block"
}

variable "db_subnets_cidr" {
  type        = list(string)
  description = "app subnet cidr block"
}

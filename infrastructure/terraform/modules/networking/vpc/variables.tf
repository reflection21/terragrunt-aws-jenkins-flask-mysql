variable "deployment_prefix" {
  type    = string
  default = "test"
}

variable "vpc_cidr" {
  type        = string
  description = "vpc cidr"
}

variable "public_subnets_cidr" {
  type        = list(string)
  description = "public subnet cidr block"
}

variable "jenkins_subnets_cidr" {
  type        = list(string)
  description = "jenkins subnet cidr block"
}

variable "app_subnets_cidr" {
  type        = list(string)
  description = "app subnet cidr block"
}

variable "rds_mysql_subnets_cidr" {
  type        = list(string)
  description = "app subnet cidr block"
}


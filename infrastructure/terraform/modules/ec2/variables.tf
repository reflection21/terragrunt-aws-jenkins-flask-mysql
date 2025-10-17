# variable "count_jenkins" {
#   type        = number
#   description = "count of jenkins master"
# }

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

# variable "count_jenkins_workers" {
#   type        = number
#   default     = 1
#   description = "count of jenkins workers"
# }

variable "jenkins_workers_subnet" {
  type        = list(string)
  description = "subnet of jenkins worker"
}

variable "jenkins_workers_sg" {
  type        = string
  description = "jenkins workers sg"
}
